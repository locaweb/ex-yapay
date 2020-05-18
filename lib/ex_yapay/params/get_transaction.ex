defmodule ExYapay.Params.GetTransaction do
  @moduledoc "This module builds the query params to get a transaction on `Yapay`."

  @behaviour ExYapay.Params

  def build(%{token_account: token_account, token_transaction: token_transaction} = attributes)
      when is_binary(token_account) and is_binary(token_transaction),
      do: {:ok, URI.encode_query(attributes)}

  def build(_),
    do: {:error, "One or more attributes are missing: `token_account` or `token_transaction`."}
end
