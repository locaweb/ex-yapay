defmodule Yapay.Client.RequestTest do
  use ExUnit.Case

  alias Yapay.Client.Request

  @fixtures_path "test/support/fixtures/get_transaction"
  @moduletag capture_log: true

  setup do
    bypass = Bypass.open()

    Application.put_env(:yapay, :base_url, "http://localhost:#{bypass.port}")

    {:ok, bypass: bypass}
  end

  describe "post/2" do
    test "returns the checkout url when request is successful", %{bypass: bypass} do
      checkout_url = "https://checkout.yapay.com.br/transacao/t3ba9d61c06296062ce718dd1b8983e45"

      request_body =
        "token_account=3f3f2f0d347797b" <>
          "&transaction_product[][code]=2" <>
          "&transaction_product[][description]=notebook" <>
          "&transaction_product[][extra]=" <>
          "&transaction_product[][price_unit]=25.25" <>
          "&transaction_product[][quantity]=2" <>
          "&transaction_product[][sku_code]=" <>
          "&transaction_product[][url_img]="

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("location", checkout_url)
        |> Plug.Conn.send_resp(302, "um body qualquer")
      end)

      assert Request.post("payment/transaction", request_body) == {:ok, checkout_url}
    end

    test "returns a bad gateway error message when response status is 502", %{bypass: bypass} do
      request_body = "token_account=3f3f2f0d347797b"

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 502, "Invalid transaction")
      end)

      assert Request.post("payment/transaction", request_body) ==
               {:error, %{body: "Invalid transaction", status: 502}}
    end

    test "returns the error message according to the type of error that occurred", %{
      bypass: bypass
    } do
      Bypass.down(bypass)

      assert Request.post("payment/transaction", "") ==
               {:error, %{body: "econnrefused", status: nil}}
    end
  end

  describe "get/2" do
    test "returns the transaction data when request is successful", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 200, File.read!("#{@fixtures_path}/success_response.json"))
      end)

      assert Request.get("api/v3/transactions/get_by_token") ==
               {:ok,
                %{
                  customer: %{
                    addresses: [
                      %{
                        city: "Campo Grande",
                        completion: "",
                        neighborhood: "Centro",
                        number: "2434",
                        postal_code: "79002003",
                        state: "MS",
                        street: "Avenida Calógeras"
                      }
                    ],
                    cnpj: "",
                    company_name: "",
                    contacts: [%{type_contact: "W", value: "1135440444"}],
                    cpf: "63804386962",
                    email: "criadordesites-dev@locaweb.com.br",
                    name: "Criador de Sites",
                    trade_name: "Criador de Sites"
                  },
                  free: "|POST| |checkout|",
                  order_number: "1576009266",
                  payment: %{
                    date_approval: 1_576_009_320,
                    date_payment: 1_576_009_320,
                    linha_digitavel: nil,
                    payment_method_id: 4,
                    payment_method_name: "Mastercard",
                    payment_response: "Mensagem de venda fake",
                    price_original: "208.0",
                    price_payment: "216.33",
                    split: 3,
                    tid: "1233",
                    url_payment: nil
                  },
                  refunds: [],
                  status_id: 6,
                  status_name: "Aprovada",
                  token_transaction: "9342ef911dd843e7a2fae4a41357727f",
                  transaction_id: 313_439
                }}
    end

    test "returns not found error when request returns `404`", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(
          conn,
          404,
          File.read!("#{@fixtures_path}/token_not_found_response.json")
        )
      end)

      assert Request.get("api/v3/transactions/get_by_token") ==
               {:error, %{body: "Transação inválida ou inexistente", status: 404}}
    end

    test "returns an error when service is down", %{bypass: bypass} do
      Bypass.down(bypass)

      assert Request.get("api/v3/transactions/get_by_token") ==
               {:error, %{body: "econnrefused", status: nil}}
    end
  end
end
