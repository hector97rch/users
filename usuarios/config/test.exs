import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :usuarios, Usuarios.Repo,
  username: "postgres",
  password: "postgres",
  database: "usuarios_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :usuarios, UsuariosWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "PX6A1p51x2Vokw6U8LJgLayIpbZMDvE5V0vC4sc1OpNq0fNYEH0ppeoa7WUQl+yW",
  server: false

# In test we don't send emails.
config :usuarios, Usuarios.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
