defmodule ExYapay.Params.CreateTransactionTest do
  use ExUnit.Case, async: true

  import ExYapay.Support.Factory

  alias ExYapay.Params.CreateTransaction

  @moduletag capture_log: true

  describe "process/1" do
    test "returns the formatted body when the attributes are valid and there is only one product" do
      attributes = %{
        account: build(:account),
        products: [build(:product)]
      }

      formatted_body =
        "token_account=3f3f2f0d347797b" <>
          "&transaction_product[][code]=1" <>
          "&transaction_product[][description]=notebook" <>
          "&transaction_product[][extra]=extra" <>
          "&transaction_product[][price_unit]=25" <>
          "&transaction_product[][quantity]=1" <>
          "&transaction_product[][sku_code]=123" <>
          "&transaction_product[][url_img]=festa-no-ape.flogao.com.br/images/2"

      {:ok, body} = CreateTransaction.build(attributes)

      assert formatted_body == body
    end

    test "returns the formatted body when there is an invalid caracter in the attributes" do
      attributes = %{
        account: build(:account),
        products: [build(:product, description: "peppa 10%", extra: "extra%")],
        reseller_token: "abcd123",
        shipping_price: 35.55,
        shipping_type: "Correios SEDEX",
        url_notification: "http://localhost/notification"
      }

      formatted_body =
        "reseller_token=abcd123" <>
          "&shipping_price=35.55" <>
          "&shipping_type=Correios+SEDEX" <>
          "&token_account=3f3f2f0d347797b" <>
          "&url_notification=http%3A%2F%2Flocalhost%2Fnotification" <>
          "&transaction_product[][code]=1" <>
          "&transaction_product[][description]=peppa 10%25" <>
          "&transaction_product[][extra]=extra%25" <>
          "&transaction_product[][price_unit]=25" <>
          "&transaction_product[][quantity]=1" <>
          "&transaction_product[][sku_code]=123" <>
          "&transaction_product[][url_img]=festa-no-ape.flogao.com.br/images/2"

      assert CreateTransaction.build(attributes) == {:ok, formatted_body}
    end

    test "returns the formatted body when there are optional attributes in the attributes" do
      attributes = %{
        account: build(:account),
        products: [build(:product)],
        reseller_token: "abcd123",
        shipping_price: 35.55,
        shipping_type: "Correios SEDEX",
        url_notification: "http://localhost/notification"
      }

      formatted_body =
        "reseller_token=abcd123" <>
          "&shipping_price=35.55" <>
          "&shipping_type=Correios+SEDEX" <>
          "&token_account=3f3f2f0d347797b" <>
          "&url_notification=http%3A%2F%2Flocalhost%2Fnotification" <>
          "&transaction_product[][code]=1" <>
          "&transaction_product[][description]=notebook" <>
          "&transaction_product[][extra]=extra" <>
          "&transaction_product[][price_unit]=25" <>
          "&transaction_product[][quantity]=1" <>
          "&transaction_product[][sku_code]=123" <>
          "&transaction_product[][url_img]=festa-no-ape.flogao.com.br/images/2"

      assert CreateTransaction.build(attributes) == {:ok, formatted_body}
    end

    test "returns the formatted body when the attributes is valid and there is more than one product" do
      notebook = build(:product)

      beyblade =
        build(:product, %{
          code: 2,
          description: "beyblade",
          price_unit: 9001,
          quantity: 10,
          sku: 456,
          url_img: "img.org/masvcchamaaambulancia.jpg"
        })

      attributes = %{
        account: build(:account),
        products: [notebook, beyblade]
      }

      formatted_body =
        "token_account=3f3f2f0d347797b" <>
          "&transaction_product[][code]=1" <>
          "&transaction_product[][description]=notebook" <>
          "&transaction_product[][extra]=extra" <>
          "&transaction_product[][price_unit]=25" <>
          "&transaction_product[][quantity]=1" <>
          "&transaction_product[][sku_code]=123" <>
          "&transaction_product[][url_img]=festa-no-ape.flogao.com.br/images/2" <>
          "&transaction_product[][code]=2" <>
          "&transaction_product[][description]=beyblade" <>
          "&transaction_product[][extra]=extra" <>
          "&transaction_product[][price_unit]=9001" <>
          "&transaction_product[][quantity]=10" <>
          "&transaction_product[][sku_code]=456" <>
          "&transaction_product[][url_img]=img.org/masvcchamaaambulancia.jpg"

      {:ok, body} = CreateTransaction.build(attributes)

      assert formatted_body == body
    end

    test "returns the formatted body no mandatory parameter is nil" do
      attributes = %{
        account: build(:account),
        products: [build(:product, code: nil, extra: nil, sku: nil, url_img: nil)]
      }

      formatted_body =
        "token_account=3f3f2f0d347797b" <>
          "&transaction_product[][code]=" <>
          "&transaction_product[][description]=notebook" <>
          "&transaction_product[][extra]=" <>
          "&transaction_product[][price_unit]=25" <>
          "&transaction_product[][quantity]=1" <>
          "&transaction_product[][sku_code]=" <>
          "&transaction_product[][url_img]="

      {:ok, body} = CreateTransaction.build(attributes)

      assert formatted_body == body
    end

    test "returns an error message when token_account is missing" do
      attributes = %{account: build(:account, token_account: nil), products: [build(:product)]}

      {:error, message} = CreateTransaction.build(attributes)

      assert message == "Invalid params. Payload: #{inspect(attributes)}"
    end

    test "returns an error message when product description is missing" do
      attributes = %{
        account: %{token_account: "3f3f2f0d347797b"},
        products: [
          %{
            code: 1,
            description: nil,
            extra: "extra",
            quantity: 1,
            sku: 123,
            price_unit: 25,
            url_img: "festa-no-ape.flogao.com.br/images/2"
          }
        ]
      }

      {:error, message} = CreateTransaction.build(attributes)

      assert message == "Invalid params. Payload: #{inspect(attributes)}"
    end

    test "returns an error message when product quantity is missing" do
      attributes = %{account: build(:account), products: [build(:product, quantity: nil)]}

      {:error, message} = CreateTransaction.build(attributes)

      assert message == "Invalid params. Payload: #{inspect(attributes)}"
    end

    test "returns an error message when product unit price is missing" do
      attributes = %{account: build(:account), products: [build(:product, price_unit: nil)]}

      {:error, message} = CreateTransaction.build(attributes)

      assert message == "Invalid params. Payload: #{inspect(attributes)}"
    end
  end
end
