defmodule Yapay.Params.CreateTransaction do
  @moduledoc "This module builds the request body to create a transaction on `Yapay`."

  alias Yapay.Resources.Product

  @behaviour Yapay.Params

  @optional_params [:reseller_token, :shipping_price, :shipping_type, :url_notification]
  @invalid_character "%"

  def build(attributes) do
    case valid?(attributes) do
      true -> {:ok, encode(attributes)}
      false -> {:error, "Invalid params. Payload: #{inspect(attributes)}"}
    end
  end

  defp valid?(attributes) do
    required_attrs = Product.required_attributes()

    !is_nil(get_in(attributes, [:account, :token_account])) &&
      Enum.all?(attributes[:products], fn product ->
        Enum.all?(required_attrs, fn attr -> product[attr] end)
      end)
  end

  defp encode(%{account: account, products: products} = attrs) do
    params =
      attrs
      |> Map.take(@optional_params)
      |> Map.merge(account)
      |> Enum.reject(fn {_key, value} -> is_nil(value) end)
      |> URI.encode_query()

    Enum.reduce(products, params, fn product, acc ->
      acc <>
        "&transaction_product[][code]=#{product.code}" <>
        "&transaction_product[][description]=#{replace_invalid_character(product.description)}" <>
        "&transaction_product[][extra]=#{replace_invalid_character(product.extra)}" <>
        "&transaction_product[][price_unit]=#{product.price_unit}" <>
        "&transaction_product[][quantity]=#{product.quantity}" <>
        "&transaction_product[][sku_code]=#{product.sku}" <>
        "&transaction_product[][url_img]=#{product.url_img}"
    end)
  end

  defp replace_invalid_character(nil), do: ""

  defp replace_invalid_character(string),
    do: String.replace(string, @invalid_character, URI.encode_www_form(@invalid_character))
end
