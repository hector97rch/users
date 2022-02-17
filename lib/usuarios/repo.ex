defmodule Usuarios.Repo do
  use Ecto.Repo,
    otp_app: :usuarios,
    adapter: Ecto.Adapters.Postgres
end
