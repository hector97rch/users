defmodule Usuarios.Email do
  use Bamboo.Mailer, otp_app: :usuarios
  use Bamboo.Phoenix, view: UsuariosWeb.EmailView
  import Bamboo.Email

  def send_email_users(user) do
    new_email()
    |> from({"greenhouse","hector@cordage.io"})
    |> to({user.name, user.email})
    |> subject("Activate your account")
    |> assign(:user, user)
    #|> assign(:token, token)
    |> render("send_email.html")
    |> deliver_now()
  end
  def reset_pasword(user) do
    new_email()
    |> from({"greenhouse","hector@cordage.io"})
    |> to({user.name, user.email})
    |> subject("Recuperar contraseña")
    |> assign(:user, user)
    #|> assign(:token, token)
    |> render("reset_password_email.html")
    |> deliver_now()
  end
end
