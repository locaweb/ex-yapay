defmodule Yapay.Support.Factory do
  @moduledoc false

  use ExMachina

  use Yapay.Support.Factories.{Account, Product, Transaction}
end
