defmodule UsuariosWeb.UserControllerTest do
  use UsuariosWeb.ConnCase

  setup  do
    conn = build_conn()
      params = conn
        |> put_req_header("content-type", "application/json")
        |> post(Routes.user_path(conn, :crear_usuario, %{name: "hector", email: "h.ector@cordage.io", estado: false }))
        |> json_response(201)
        {:ok, params: params}
    end
#---------------crear usuario----------------------------------------------------
    test "create user succesfully" do
      conn = build_conn()
      response = conn
      |> put_req_header("content-type", "application/json")
      |> post(Routes.user_path(conn, :crear_usuario, %{name: "hector", email: "hector@cordage.io"}))
      |> json_response(201)
      assert  %{
        "id"=> _id,
        "name" => _name,
        "email" => _email,
        "estado" => _estado

      } = response
    end

     test "create user unsuccesfully" do
      conn = build_conn()
      response = conn
      |> put_req_header("content-type", "application/json")
      |> post(Routes.user_path(conn, :crear_usuario, %{name: "hector", email: "h.ector@cordage.io"}))
      |> json_response(400)

      assert  %{"error" => "No se pudo crear el usuario"} = response
     end

#     #--------------mostar usuario---------------
    test "show_usuario succesfully", %{params: params} do
      conn = build_conn()
      response = conn
        |>get(Routes.user_path(conn, :show_usuario, params["id"]))
        |>json_response(200)

      assert  %{
        "id" => _id,
        "name" => _name,
        "email" => _email
      } = response
    end

    test "show_usuario unsuccesfully" do
      conn = build_conn()
      response = conn
        |>get(Routes.user_path(conn, :show_usuario, 0))
        |>json_response(400)

        assert  %{
          "error" => _error
      } = response
    end
# #----------------mostar usuarios------------------------
    test "show_usuarios succesfully" do
      conn = build_conn()
      response = conn
        |>get(Routes.user_path(conn, :show_usuarios))
        |>json_response(200)

      assert  [%{
        "id" => _id,
        "name" => _name,
        "email" => _email
      }] = response
    end

#     #---------------actualizar usuario-----------------------------------------
    test "update user succesfully", %{params: params} do
      conn = build_conn()
      response = conn
      |>put(Routes.user_path(conn, :update_usuario, params["id"]))
      |>response(205)
      assert "Actualizado hector, h.ector@cordage.io" == response
    end

    test "update user unsuccesfully" do
      conn = build_conn()
      response = conn
      |>put(Routes.user_path(conn, :update_usuario, %{name: "mame", email: ""}))
      |>response(205)
      assert "No se pudo actualizar el usuario" == response
    end
# #---------------actualizar password------------------------------------
    test "update password succesfully", %{params: params} do
      conn = build_conn()
      response = conn
      |>put(Routes.user_path(conn, :update_password, params["id"]))
      |>response(205)
      assert "Contraseña Actualizada" == response
    end
# #----------eliminar usuario---------------------------------------
    test "eliminar succesfully", %{params: params} do
      conn = build_conn()
        response = conn
        |>delete(Routes.user_path(conn, :delete_usuario, params["id"]))
        |>response(200)
        assert "Eliminado" == response
    end
# #--------------reset password-----------------------------
    test "reset password succesfully", %{params: params} do
          conn = build_conn()
          response = conn
            |>post(Routes.user_path(conn, :reset_password, params["id"]))
            |>json_response(205)

          assert  [%{
            "id" => _id
          }] = response

    end


    def crear_usuario do
      ~s({
        "usuario":{
          "name": "hector",
          "email": "hector@cordage.io"},
          "estado": false
      })
      end
end
