defmodule Yapay do
  @moduledoc """
  A client for the `Yapay Intermediador API`.

  More information can be found on the yapay doc: http://dev.yapay.com.br/intermediador/apis.
  """

  alias Yapay.Resources
  alias Yapay.Resources.{Account, Product}
  alias Yapay.Transaction

  @typep options :: [parser: atom(), request: atom()]
  @typep reason :: %{body: String.t(), status: integer()}

  @type create_attributes :: %{
          account: %Account{},
          products: [%Product{}],
          reseller_token: String.t(),
          shipping_price: float(),
          shipping_type: String.t(),
          url_notification: String.t()
        }

  @doc """
  Creates a transaction via POST request to Yapay and return its checkout url.

  ## Examples

    iex> attributes = %{
      account: %{token_account: "3f3f2f0d347797b"},
      products: [
        %{
          code: 1,
          description: "notebook",
          extra: nil,
          price_unit: 10,
          quantity: 1,
          sku: 123,
          url_img: "some.product/url"
        }
      ],
      reseller_token: "a1w0l2l1231lpw0pa",
      shipping_price: 23.39,
      shipping_type: "Correios SEDEX",
      url_notification: "http://localhost:4003/notifications/status?site_id=123&cart_id=445"
    }
    iex> Yapay.create_transaction(attributes)
    {:ok, "https://checkout.yapay.com.br/transacao/ta679ae0f5f25e814a0d79bd35ee292d4"}

  """
  @spec create_transaction(create_attributes(), options()) ::
          {:ok, String.t()} | {:error, reason()}
  defdelegate create_transaction(attributes, opts \\ []), to: Transaction, as: :create

  @doc """
  Gets a transaction by `token_account` and `token_transaction`.

  ## Examples

    iex> Yapay.get_transaction("6f43694d9ec6057", "9342ef911dd843e7a2fae4a41357727f")
    {:ok,
     %Yapay.Resources.Transaction{
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
         cpf: "11122233388",
         email: "example@example.com.br",
         name: "Criador de Sites",
         trade_name: "Criador de Sites"
       },
       free: "|POST| |checkout|",
       order_number: "1576009266",
       payment: %{
         date_approval: 1576009320,
         date_payment: 1576009320,
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
       transaction_id: 313439
     }}

    iex> Yapay.get_transaction("6f43694d9ec6057", "123")
    {:error, %{body: "Transação não encontrada", status: 404}}

  """
  @spec get_transaction(String.t(), String.t(), options()) ::
          {:ok, Resources.Transaction.t()} | {:error, reason()}
  defdelegate get_transaction(token_account, token_transaction, opts \\ []),
    to: Transaction,
    as: :get
end
