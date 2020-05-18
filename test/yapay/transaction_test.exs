defmodule Yapay.TransactionTest do
  use ExUnit.Case, async: true

  import Mox
  import Yapay.Support.Factory

  alias Yapay.Resources
  alias Yapay.{ClientMock, ParamsMock, Transaction}

  @moduletag capture_log: true

  setup :verify_on_exit!

  describe "create/2" do
    test "returns the checkout url when the transaction params are valid" do
      expect(ParamsMock, :build, fn _attributes -> {:ok, "formatted_body"} end)

      expect(ClientMock, :post, fn _url, _formatted_body ->
        {:ok, "check.out/url"}
      end)

      assert Transaction.create("valid_transaction_params",
               params: ParamsMock,
               request: ClientMock
             ) ==
               {:ok, "check.out/url"}
    end

    test "returns an error message when the transaction params are invalid" do
      expect(ParamsMock, :build, fn _attributes ->
        {:error, "Invalid params. Payload: invalid_transaction_params"}
      end)

      assert Transaction.create("invalid_transaction_params", params: ParamsMock) ==
               {:error, "Invalid params. Payload: invalid_transaction_params"}
    end

    test "returns an error message when the transaction params are valid, but the request goes wrong" do
      expect(ParamsMock, :build, fn _attributes -> {:ok, "formatted_body"} end)

      expect(ClientMock, :post, fn _url, _formatted_body ->
        {:error, "req_timeout"}
      end)

      assert Transaction.create("valid_transaction_params",
               params: ParamsMock,
               request: ClientMock
             ) ==
               {:error, "req_timeout"}
    end
  end

  describe "get/3" do
    test "returns the transaction resource when client's get function returns the transaction data" do
      expect(ParamsMock, :build, fn _attributes ->
        {:ok, "token_account=123&token_transaction=456"}
      end)

      expect(ClientMock, :get, fn _url -> {:ok, build(:transaction)} end)

      assert {:ok, %Resources.Transaction{} = transaction} =
               Transaction.get("123", "456", params: ParamsMock, request: ClientMock)

      assert transaction.status_name == "Aprovada"
    end

    test "returns an error when client's get function returns not found" do
      error = {:error, %{body: "Transação inválida ou inexistente", status: 404}}

      expect(ParamsMock, :build, fn _attributes ->
        {:ok, "token_account=123&token_transaction=456"}
      end)

      expect(ClientMock, :get, fn _url -> error end)

      assert Transaction.get("123", "000", params: ParamsMock, request: ClientMock) == error
    end

    test "returns an error when attributes are invalid" do
      error =
        {:error, "One or more attributes are missing: `token_account` or `token_transaction`."}

      expect(ParamsMock, :build, fn _attributes -> error end)

      assert Transaction.get("123", nil, params: ParamsMock) == error
    end
  end
end
