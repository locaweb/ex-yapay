defmodule Yapay.Params.GetTransactionTest do
  use ExUnit.Case, async: true

  alias Yapay.Params.GetTransaction

  describe "build/1" do
    test "returns encoded attributes when `token_account` and `token_transaction` are given" do
      assert GetTransaction.build(%{token_account: "123", token_transaction: "456"}) ==
               {:ok, "token_account=123&token_transaction=456"}
    end

    test "returns an error when `token_account` is not given" do
      assert {:error, _} = GetTransaction.build(%{token_transaction: "456"})
      assert {:error, _} = GetTransaction.build(%{token_account: nil, token_transaction: "456"})
    end

    test "returns an error when `token_transaction` is not given" do
      assert {:error, _} = GetTransaction.build(%{token_account: "456"})
      assert {:error, _} = GetTransaction.build(%{token_account: "456", token_transaction: nil})
    end

    test "returns an error when `token_account` and `token_transaction` are not given" do
      assert {:error, _} = GetTransaction.build(%{})
      assert {:error, _} = GetTransaction.build(%{token_account: nil, token_transaction: nil})
    end
  end
end
