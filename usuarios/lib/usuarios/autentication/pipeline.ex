defmodule Usuarios.Guardian.AuthPipeline do
  @claims %{typ: "access"}
  use Guardian.Plug.Pipeline,
      otp_app: :Usuarios,
      module: Usuarios.Guardian,
      error_handler: Usuarios.Guardian.AuthErrorHandler

      plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer")
      plug(Guardian.Plug.EnsureAuthenticated)
      plug(Guardian.Plug.LoadResource, ensure: true)
end
