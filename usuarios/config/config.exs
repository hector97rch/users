# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :usuarios,
  ecto_repos: [Usuarios.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :usuarios, Usuarios.Mailer, adapter: Swoosh.Adapters.Local
config :phoenix_swagger, json_library: Jason
# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false



# Configures the endpoint
# config :usuarios_web, UsuariosWeb.Endpoint,
#   url: [host: "localhost"],
#   render_errors: [view: UsuariosWeb.ErrorView, accepts: ~w(html json), layout: false],
#   pubsub_server: Usuarios.PubSub,
#   live_view: [signing_salt: "/+aHRyuf"]

  config :usuarios, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: UsuariosWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: UsuariosWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../apps/usuarios_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :usuarios, Usuarios.Guardian,
issuer: "usuarios",
secret_key: "mysecretkey"


config :usuarios, Usuarios.Email,
adapter: Bamboo.SMTPAdapter,
server: "smtp.sendgrid.net",
hostname: "smtp.sendgrid.net",
port: 587,
username: "apikey",
password: "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",
tls: :if_available,
allowed_tls_versions: [:"tlsv1", :"tlsv1.1", :"tlsv1.2"],
ssl: false,
retries: 1,
no_mx_lookups: false,
auth: :if_available
