defmodule Yapay.Support.Factories.Product do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def product_factory do
        %{
          code: 1,
          description: "notebook",
          extra: "extra",
          price_unit: 25,
          quantity: 1,
          sku: 123,
          url_img: "festa-no-ape.flogao.com.br/images/2"
        }
      end
    end
  end
end
