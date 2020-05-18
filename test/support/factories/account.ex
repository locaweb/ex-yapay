defmodule ExYapay.Support.Factories.Account do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def account_factory, do: %{token_account: "3f3f2f0d347797b"}
    end
  end
end
