defmodule ExYapay.Params do
  @moduledoc false

  @doc "Returns the encoded request body."
  @callback build(map()) :: {:ok, String.t()} | {:error, String.t()}
end
