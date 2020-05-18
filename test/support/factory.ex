defmodule ExYapay.Support.Factory do
  @moduledoc false

  use ExMachina

  use ExYapay.Support.Factories.{Account, Product, Transaction}
end
