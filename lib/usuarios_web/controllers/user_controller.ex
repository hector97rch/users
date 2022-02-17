defmodule UsuariosWeb.UserController do
  use UsuariosWeb, :controller
  use PhoenixSwagger
  alias Usuarios.Email
  alias Usuarios.Functions
  action_fallback UsuariosWeb.UserErrorController

  # coveralls-ignore-start
  def swagger_definitions do
    %{
      User: swagger_schema do
        title "users"
        description "database for the login application"
        properties do
          id :string, "Unique identifier", required: true
          name :string, "Users name", required: true
          email :string, "email for users", required: true
          password :string, "users password", required: true
          estado :boolean, "users estado", required: false
        end
        example %{
          id: "1",
          name: "pedro",
          email: "pedro@email.com",
          password: "sdfjnvdfvbjhvbxbvsdjs"
        }
      end,
      Users: swagger_schema do
        title "Users"
        description "A collection of Users"
        type :array
      items Schema.ref(:User)
      end
    }
  end
# coveralls-ignore-stop


  def crear_usuario(conn, attrs) do
    case Usuarios.Functions.crear_usuario(attrs) do
        {:ok, usuario} ->
        Email.send_email_users(usuario)
        conn
          |> put_status(201)
          |> render("usuario.json", %{usuario: usuario})
        {:error, changeset}->
          {:error, "No se pudo crear el usuario"}
    end
  end
   # coveralls-ignore-start
  swagger_path :crear_usuario do
    post "/api/users"
    summary "create user"
    description "add user in the database"
    produces "application/json"
    deprecated(false)
    operation_id "crear_usuario"
    parameters do
      id :string, "Unique identifier", required: true
      name :string, "Users name", required: true
      email :string, "email for users", required: true
    end
    response 201, "usuario.json", Schema.ref(:Users)
    response 400, ":error"
  end
# coveralls-ignore-stop

  def show_usuarios(conn, _params) do
    usuarios = Usuarios.User.buscar_usuarios()
    case usuarios != [] do
        true ->
          conn
            |>put_status(200)
            |> put_resp_content_type("application/json")
            |>render("usuarios.json", %{usuarios: usuarios})
        false ->
          {:error, "no hay usuarios"}
    end
  end
   # coveralls-ignore-start
  swagger_path :show_usuarios do
    PhoenixSwagger.Path.get "/api/users"
    summary "show all users"
    description "list all users on json"
    produces("application/json")
    response 200, "lista de usuarios"
    response 400, "no hay usuarios"
  end
 # coveralls-ignore-stop

  def show_usuario(conn, %{"id" => id}) do
      case Usuarios.User.buscar_usuario(id) do
        nil->
          {:error, "usuario no encontrado!"}
        usuario->
          conn
            |> put_status(200)
            |> render("usuario.json", %{usuario: usuario})
      end
  end
   # coveralls-ignore-start
  swagger_path :show_usuario do
    PhoenixSwagger.Path.get "/api/users/id"
    summary "show all users"
    description "list one user on json"
    produces("application/json")
    response 200, "usuario"
    response 400, "usuario no encontrado"
  end
   # coveralls-ignore-stop

  def delete_usuario(conn, attrs) do
    del = Usuarios.Functions.eliminar_usuario(attrs)
    case del do
      {:ok, usuario}->
        conn
            |>put_status(200)
            |>text("Eliminado")
      {:error, changeset}->

        {:error, "No se pudo eliminar el usuario"}
    end
  end
  # coveralls-ignore-start
  swagger_path :delete_usuario do
    PhoenixSwagger.Path.delete "/api/users/:id"
    summary "Delete User"
    description "Delete a user by ID"
    parameter :id, :path, :integer, "Usuario ID", required: true, example: 3
    response 200, "Eliminado"
    response 400, "no detelted"
  end
  # coveralls-ignore-stop

  @spec update_usuario(any, map) :: {:error, <<_::168>>} | Plug.Conn.t()
  def update_usuario(conn, attrs) do
    upt = Usuarios.Functions.actualizar_usuario(attrs)
    case upt do
      {:ok, usuario}->
        conn
            |>put_status(205)
            |>text("Actualizado #{usuario.name}, #{usuario.email}")
      {:error, changeset}->

        {:error, "No se pudo actualizar el usuario"}
    end
  end
    # coveralls-ignore-start
    swagger_path :update_usuario do
      put("/manager/users/{id}")
      summary "Update User"
      description "Update a user by ID"
      produces("aplication/json")
      deprecated(false)
      parameters do
        id :path, :string, "Unique identifier", required: true
        name :string, "User name", required: true
        email :string, "email for users", required: true

      end
      response 205, "Actualizado"
      response 400, "No se pudo actualizar"
    end
    # coveralls-ignore-stop

  def update_password(conn, attrs) do
    upt = Usuarios.Functions.actualizar_password(attrs)
    case upt do
      {:ok, usuario}->
        conn
            |>put_status(205)
            |>text("Contraseña Actualizada")
      {:error, changeset }->

        {:error, "no se pudo actualizar el password"}
    end
  end
     # coveralls-ignore-start
     swagger_path :update_password do
      put("/manager/users/{id}")
      summary "Update password"
      description "Update password by ID"
      produces("aplication/json")
      deprecated(false)
      parameters do
        id :path, :string, "Unique identifier", required: true
        password :string, "User password", required: true


      end
      response 205, "Actualizada"
      response 400, "No se pudo actualizar"
    end
    # coveralls-ignore-stop

  def reset_password(conn, attrs) do
    comp_email= Usuarios.Functions.ress_pass(attrs)
    case comp_email do
      usuario->
        Email.reset_pasword(usuario)
        conn
            |>put_status(205)
            |>render("idusuario.json", %{usuario: usuario})
      changeset ->
        {:error, "no se pudo enviar el correo"}
    end
  end
end
