defmodule Yapay.Resources.Transaction do
  @moduledoc "This structure represents a `Yapay` transaction."

  @typep address :: %{
           city: String.t(),
           completion: String.t(),
           neighborhood: String.t(),
           number: String.t(),
           postal_code: String.t(),
           state: String.t(),
           street: String.t()
         }

  @typep contact :: %{
           type_contact: String.t(),
           value: String.t()
         }

  @typep customer :: %{
           addresses: [address()],
           cnpj: String.t(),
           company_name: String.t(),
           contacts: [contact()],
           cpf: String.t(),
           email: String.t(),
           name: String.t(),
           trade_name: String.t()
         }

  @typep payment :: %{
           date_approval: integer(),
           date_payment: integer(),
           linha_digitavel: String.t(),
           payment_method_id: integer(),
           payment_method_name: String.t(),
           payment_response: String.t(),
           price_original: String.t(),
           price_payment: String.t(),
           split: integer(),
           tid: String.t(),
           url_payment: String.t()
         }

  @type t :: %__MODULE__{
          customer: customer(),
          free: String.t(),
          order_number: String.t(),
          payment: payment(),
          refunds: list(),
          status_id: String.t(),
          status_name: String.t(),
          token_transaction: String.t(),
          transaction_id: String.t()
        }

  defstruct [
    :customer,
    :free,
    :order_number,
    :payment,
    :refunds,
    :status_id,
    :status_name,
    :token_transaction,
    :transaction_id
  ]
end
