import Config

config :yapay,
  base_url: System.get_env("YAPAY_URL") || "https://intermediador.sandbox.yapay.com.br"
