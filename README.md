# ExYapay

Elixir client that integrates with Yapay.

## Installation

```elixir
def deps do
  [
    {:ex_yapay, "~> 1.0.1"}
  ]
end
```

## Usage

### Configuration

Add the following config to your config.exs file:

```elixir
config :ex_yapay,
  base_url: System.get_env("YAPAY_URL") || "https://intermediador.yapay.com.br",
  request_post_prefix: System.get_env("YAPAY_REQUEST_POST_PREFIX") || "tc.",
  ibrowse_opts: [],
  timeout: 10000
```

Both `YAPAY_URL` and `YAPAY_REQUEST_POST_PREFIX` will need to be set differently depending on the environment:

#### Sandbox

```bash
YAPAY_URL=https://intermediador-sandbox.yapay.com.br
YAPAY_REQUEST_POST_PREFIX=tc-
```

#### Production

```bash
YAPAY_URL=https://intermediador.yapay.com.br
YAPAY_REQUEST_POST_PREFIX=tc.
```

In case none of these are set, the environment you are using is assumed to be production.

### Create a Transaction

The function `create_transaction` expects a map containing an account and a list of products, like so:

```elixir
attributes = %{
  account: %{token_account: "3f3f2f0d347797b"},
  products: [
    %{
      code: 1,
      description: "notebook",
      extra: nil,
      price_unit: 10,
      quantity: 1,
      sku: 123,
      url_img: "https://some.product/url"
    }
  ],
  reseller_token: "a1w0l2l1231lpw0pa",
  shipping_price: 23.39,
  shipping_type: "Correios SEDEX",
  url_notification: "http://localhost:4003/notifications/status?site_id=123&cart_id=445"
}
```

In the struct described above, the mandatory values to start the process are `token_account`, `description`, `price_unit` and `quantity`. Values other than those can be `nil`, but their keys are required as well.

In order to receive the checkout url, the only call to be made is:

```elixir
ExYapay.create_transaction(attributes)
```

Which will return either:

```elixir
{:ok, "some.checkout/url"}
```

Or

```elixir
{:error, %{body: 400, body: "message the reflects what went wrong"}}
```

### Get a Transaction

The function `get_transaction` expects the `token_account` and `token_transaction`:

```elixir
ExYapay.get_transaction("6f43694d9ec6057", "9342ef911dd843e7a2fae4a41357727f")
{:ok,
 %ExYapay.Resources.Transaction{
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
     email: "your.email@example.com",
     name: "Locaweb",
     trade_name: "Locaweb"
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
```

If an error occurs, the answer will be as follows:

```elixir
ExYapay.get_transaction("6f43694d9ec6057", "123")
{:error, %{body: "Transação não encontrada", status: 404}}
```

## Running tests

```bash
mix test
```

## Running code formatter

```bash
mix format
```

## Credo

Credo is a static code analysis tool for the Elixir language, to run credo:

```
$ mix credo --strict
```

## Contributing

Check out the [Contributing](CONTRIBUTING.md) guide.

## License

ExYapay is released under the MIT license. See the [License](LICENSE.md) file.
