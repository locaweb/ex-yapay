import Config

config :ex_yapay,
  base_url: System.get_env("YAPAY_URL") || "https://intermediador.yapay.com.br",
  ibrowse_opts: [],
  timeout: 10_000

import_config "#{Mix.env()}.exs"
