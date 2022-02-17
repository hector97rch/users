defmodule Usuarios.Functions do
  import Ecto.Query
  import Ecto.Schema
  import Ecto.Query
  alias Usuarios.Repo
  alias Usuarios.User

#----------------------------- crud--------------------------------------
    def crear_usuario(attrs \\ %{}) do
      attrs
        |> User.crear_usuario_changeset()
        |> Usuarios.Repo.insert()
    end

    def ress_pass(attrs \\ %{})do
      attrs
      |> User.get_email_changset()
    end


    def actualizar_usuario(attrs \\ %{}) do
      attrs
        |> User.actualizar_usuario_changeset()
        |> Usuarios.Repo.update()
    end
    def actualizar_password(attrs \\ %{}) do
      attrs
        |> User.actualizar_password_changeset()
        |> Usuarios.Repo.update()
    end

    @spec eliminar_usuario(
            :invalid
            | %{optional(:__struct__) => none, optional(atom | binary) => any}
          ) :: any
    def eliminar_usuario(attrs \\ %{}) do
      attrs
        |> User.eliminar_usuario_changeset()
        |> Usuarios.Repo.delete()
    end

    #----------------------autenticacion-------------------------

    def get_by_email(email) do
      query = from u in User, where: u.email == ^email

      case Repo.one(query) do
        nil -> {:error, :not_found}
        user -> {:ok, user}
      end
    end

    def get_by_id!(id) do
      User |> Repo.get!(id)
    end

    def autenticate_user(email, password) do
      cond do
        not is_nil(email) ->
        cond do
          not is_nil(password) ->
            with {:ok, user} <- get_by_email(email)do
              case validate_password(password, user.encrypted_password)do
                false -> {:error, :unautorized}
                true -> {:ok, user}
            end
              end
        true -> {:error, :not_found_email}
      end
        true -> {:error, :not_found_password}
        end
    end

defp validate_password(password, encrypted_password) do
  Pbkdf2.verify_pass(password, encrypted_password)
end
  end
