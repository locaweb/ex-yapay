defmodule Yapay.Client do
  @moduledoc false

  @typep headers :: [String.t()]
  @typep reason :: %{body: String.t(), status: integer()}
  @typep response :: {:ok, String.t() | map()} | {:error, reason()}

  @doc "Posts a transaction and returns the checkout url."
  @callback post(String.t(), String.t()) :: response()
  @callback post(String.t(), String.t(), headers()) :: response()

  @doc "Gets a transaction."
  @callback get(String.t()) :: response()
  @callback get(String.t(), headers()) :: response()
end
