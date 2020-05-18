defmodule ExYapay.Transaction do
  @moduledoc """
  This module provides functions to manage transactions on `Yapay Intermediador API`.

  More information about a `Transaction` can be found on the yapay docs:

  * https://intermediador.dev.yapay.com.br/#/transacao-tabela-campos.
  * https://intermediador.dev.yapay.com.br/#/integracao-post-criando
  * https://intermediador.dev.yapay.com.br/#/api-consultar-transacao
  """

  alias ExYapay.Client.Request
  alias ExYapay.Params.{CreateTransaction, GetTransaction}
  alias ExYapay.Resources

  @typep options :: [parser: atom(), request: atom()]
  @typep reason :: %{body: String.t(), status: integer()}

  @create_path "payment/transaction"
  @get_path "api/v3/transactions/get_by_token"

  @doc "Creates a transaction and returns the checkout url."
  @spec create(map(), options()) :: {:ok, String.t()} | {:error, reason()}
  def create(attributes, opts) do
    params = opts[:params] || CreateTransaction
    request = opts[:request] || Request

    with {:ok, params} <- params.build(attributes) do
      request.post(@create_path, params)
    end
  end

  @doc "Gets a transaction by `token_account` and `token_transaction`."
  @spec get(String.t(), String.t(), options()) ::
          {:ok, Resources.Transaction.t()} | {:error, reason()}
  def get(token_account, token_transaction, opts \\ []) do
    params = opts[:params] || GetTransaction
    request = opts[:request] || Request

    attributes = %{token_account: token_account, token_transaction: token_transaction}

    with {:ok, params} <- params.build(attributes),
         {:ok, response} <- request.get("#{@get_path}?#{params}") do
      {:ok, struct(Resources.Transaction, response)}
    end
  end
end
