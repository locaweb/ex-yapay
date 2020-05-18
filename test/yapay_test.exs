defmodule YapayTest do
  use ExUnit.Case

  import Mox

  alias Yapay.ParamsMock
  alias Yapay.Resources.Transaction

  @fixtures_path "test/support/fixtures/get_transaction"
  @moduletag capture_log: true

  setup do
    bypass = Bypass.open()

    Application.put_env(:yapay, :base_url, "http://localhost:#{bypass.port}")

    {:ok, bypass: bypass}
  end

  describe "create_transaction/1" do
    test "returns the checkout url when the cart params are valid", %{bypass: bypass} do
      expect(ParamsMock, :build, fn _attributes -> {:ok, "formatted_body"} end)

      checkout_url = "https://checkout.yapay.com.br/transacao/t3ba9d61c06296062ce718dd1b8983e45"

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("location", checkout_url)
        |> Plug.Conn.send_resp(302, "um body qualquer")
      end)

      assert Yapay.create_transaction("valid_cart_params", params: ParamsMock) ==
               {:ok, checkout_url}
    end

    test "returns the error message when the cart params are invalid" do
      expect(ParamsMock, :build, fn _attributes ->
        {:error, "Invalid params. Payload: invalid_cart_params"}
      end)

      assert Yapay.create_transaction("invalid_cart_params", params: ParamsMock) ==
               {:error, "Invalid params. Payload: invalid_cart_params"}
    end

    test "returns the error message when the cart params are valid, but the request goes wrong",
         %{bypass: bypass} do
      expect(ParamsMock, :build, fn _attributes -> {:ok, "formatted_body"} end)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 502, "Invalid transaction")
      end)

      assert Yapay.create_transaction("valid_cart_params", params: ParamsMock) ==
               {:error, %{body: "Invalid transaction", status: 502}}
    end
  end

  describe "get_transaction/2" do
    test "returns a transaction when the transaction exists", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 200, File.read!("#{@fixtures_path}/success_response.json"))
      end)

      assert Yapay.get_transaction("6f43694d9ec6057", "9342ef911dd843e7a2fae4a41357727f") ==
               {:ok,
                %Transaction{
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

    test "returns an error when the transaction does not exist", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(
          conn,
          404,
          File.read!("#{@fixtures_path}/token_not_found_response.json")
        )
      end)

      assert Yapay.get_transaction("6f43694d9ec6057", "123") ==
               {:error, %{body: "Transação inválida ou inexistente", status: 404}}
    end

    test "returns an error when service is down", %{bypass: bypass} do
      Bypass.down(bypass)

      assert Yapay.get_transaction("6f43694d9ec6057", "9342ef911dd843e7a2fae4a41357727f") ==
               {:error, %{body: "econnrefused", status: nil}}
    end
  end
end
