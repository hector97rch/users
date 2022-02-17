defmodule UsuariosWeb.UserControllerTest do
  use UsuariosWeb.ConnCase

  setup  do
    conn = build_conn()
      params = conn
        |> put_req_header("content-type", "application/json")
        |> post(Routes.user_path(conn, :crear_usuario, %{email: "h.ector@cordage.io", password: "123456Aa@", estado: true}))
        |> json_response(201)
        {:ok, params: params}
    end


test "create token succesfully" do
  conn = build_conn()
  response = conn
  |> put_req_header("content-type", "application/json")
  |> post(Routes.user_path(conn, :crear_usuario, %{email: "h.ector@cordage.io", password: "123456Aa@", estado: true}))
  |> json_response(201)
  assert "sesion iniciada" == response
end


test "delete token succesfully", %{params: params} do
  conn = build_conn()
  response = conn
  |>put(Routes.user_path(conn, :delete, params))
  |>response(205)
  assert "sesion finalizada" == response
end


test "delete token unccesfully"  do
  conn = build_conn()
  response = conn
  |>put(Routes.user_path(conn, :delete))
  |>json_response(400)
  assert  %{
    "errors" =>  _error
} = response
end
