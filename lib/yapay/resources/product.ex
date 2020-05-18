defmodule Yapay.Resources.Product do
  @moduledoc false

  @enforce_keys [:code, :description, :extra, :price_unit, :quantity, :sku, :url_img]

  defstruct @enforce_keys

  @spec required_attributes() :: [atom()]
  def required_attributes, do: [:description, :price_unit, :quantity]
end
