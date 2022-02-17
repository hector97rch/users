defmodule UsuariosWeb.SessionController do
  use UsuariosWeb, :controller
 # use PhoenixSwagger

  alias Usuarios.Functions

  action_fallback UsuariosWeb.FallbackController

  def new(conn, %{"email" => email, "password" => password})do
    case Functions.autenticate_user(email, password)do
      {:ok, user} ->
        {:ok, access_token, _claims} =
          Guardian.encode_and_sign(Usuarios.Guardian, user, %{}, token_type: "access", ttl: {60, :minute})

        {:ok, refresh_token, _claims} =
          Guardian.encode_and_sign(Usuarios.Guardian, user, %{}, token_type: "refresh", ttl: {6, :day})

        conn
          |>put_resp_cookie("ruid", refresh_token)
          |>put_status(:created)
          |>render("token.json", access_token: access_token)

    {:error, :unaitorized} ->
      body = Jason.encode!(%{error: "unautorized"})
      conn
        |> send_resp(401, body)
    end
  end

  def refresh(conn, _params) do
    refresh_token =
      Plug.Conn.fetch_cookies(conn) |> Map.from_struct() |> get_in([:cookies, "ruid"])

      case Guardian.exchange(Usuarios.Guardian, refresh_token, "refresh", "access", []) do
        {:ok, _old_stuff, {new_access_token, _new_claims}} ->
          conn
            |>put_status(:created)
            |>render("token.json", %{access_token: new_access_token})

        {:error, :unaitorized} ->
          body = Jason.encode!(%{error: "unautorized"})

          conn
          |> send_resp(401, body)

      end
    end

  def delete(conn, _params) do
    conn
    |>delete_resp_cookie("ruid")
    |> put_status(200)
    |> text("log out successful")
  end

end
