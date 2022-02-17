defmodule Usuarios.Tokens do

  def email_token(data) do
    Phoenix.Token.sing(UsuariosWeb.Enndpoint, "email", data)
    end
  @spec verify_email(nil | binary) :: {:error, :expired | :invalid | :missing} | {:ok, any}
  def verify_email (token) do
    case Phoenix.Token.verify(UsuariosWeb.Enndpoint, "email", token, max_age: 345600000) do #4 dias
      {:ok, data} -> {:ok, data}
      _error -> {:error, :unauthenticated}
    end
  end

end
