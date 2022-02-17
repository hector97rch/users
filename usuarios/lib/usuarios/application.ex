defmodule Usuarios.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
# coveralls-ignore-start
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Usuarios.Repo,
      # Start the Telemetry supervisor
      UsuariosWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Usuarios.PubSub},
      # Start the Endpoint (http/https)
      UsuariosWeb.Endpoint
      # Start a worker by calling: Usuarios.Worker.start_link(arg)
      # {Usuarios.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Usuarios.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UsuariosWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
# coveralls-ignore-stop
