defmodule UsuariosWeb.UserErrorController do
  use UsuariosWeb, :controller
# coveralls-ignore-start

  def call(conn, {:error, error}) do
    conn
      |> put_status(400)
      |> json(%{error: error})
  end
  def call(conn, {:error, :not_found_email}) do
    conn
    |> put_status(404)
    |> json(%{error: "no se ingreso el email"})
  end
  def call(conn, {:error, :not_found_password}) do
    conn
    |> put_status(404)
    |> json(%{error: "no se ingreso el password"})
  end
  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(403)
    |> json(%{error: "no autorizado"})
  end

end
# coveralls-ignore-stop
