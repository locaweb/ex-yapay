defmodule ExYapay.Support.Factories.Transaction do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def transaction_factory do
        %{
          customer: %{
            addresses: [
              %{
                city: "Campo Grande",
                completion: "",
                neighborhood: "Centro",
                number: "2434",
                postal_code: "79002003",
                state: "MS",
                street: "Avenida Calógeras"
              }
            ],
            cnpj: "",
            company_name: "",
            contacts: [%{type_contact: "W", value: "1135440444"}],
            cpf: "63804386962",
            email: "criadordesites-dev@locaweb.com.br",
            name: "Criador de Sites",
            trade_name: "Criador de Sites"
          },
          free: "|POST| |checkout|",
          order_number: "1576009266",
          payment: %{
            date_approval: 1_576_009_320,
            date_payment: 1_576_009_320,
            linha_digitavel: nil,
            payment_method_id: 4,
            payment_method_name: "Mastercard",
            payment_response: "Mensagem de venda fake",
            price_original: "208.0",
            price_payment: "216.33",
            split: 3,
            tid: "1233",
            url_payment: nil
          },
          refunds: [],
          status_id: 6,
          status_name: "Aprovada",
          token_transaction: "9342ef911dd843e7a2fae4a41357727f",
          transaction_id: 313_439
        }
      end
    end
  end
end
