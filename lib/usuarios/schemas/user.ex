defmodule Usuarios.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :estado, :boolean
    timestamps()
  end

  defp get_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:id])
    |> validate_required([:id])
    |> get_usuario()
  end
  defp get_usuario(changeset) do
    case changeset.valid? do
      true ->
        case Usuarios.Repo.get(__MODULE__, get_field(changeset, :id)) do
          nil -> add_error(changeset, :id, "Usuario no encontrado")
          usuario -> usuario
        end
      false -> changeset
    end
  end

  def crear_usuario_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_format(:name, ~r{^[a-zA-Z ]+$})
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    #coveralls-ignore-start
    |> usuario_estado_inactivo()
    #coveralls-ignore-stop
  end

  @spec actualizar_password_changeset(
          :invalid
          | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def actualizar_password_changeset(attrs) do
    attrs
    |> get_changeset()
    |> cast(attrs, [:password])
    #|> validate_required([:password])
    # |> validate_length(:password, min: 6)
    # |> validate_format(:password, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{6,15}/)
    # |> usuario_estado_activo()
    #|> encrypt_password()

  end

  defp encrypt_password(changeset)  do
    password = get_change(changeset, :password)
    encrypted_password = Pbkdf2.hash_pwd_salt(password)
    put_change(changeset, :encrypted_password, encrypted_password)
  end


  defp usuario_estado_inactivo(%{valid?: true} = changeset) do
    changeset
    |> put_change(:estado, false)
  end
  defp usuario_estado_activo(%{valid?: false} = changeset), do: changeset

  defp usuario_estado_activo(%{valid?: true} = changeset) do
    changeset
    |> put_change(:estado, true)
  end

  def actualizar_usuario_changeset(attrs) do
    attrs
    |> get_changeset()
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])

  end

  @spec eliminar_usuario_changeset(
          :invalid
          | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: any
  def eliminar_usuario_changeset(attrs) do
    attrs
    |> get_changeset()
  end

  @spec get_email_changset(
          :invalid
          | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: any
  def get_email_changset(attrs) do
     %__MODULE__{}
     |> cast(attrs, [:email])
     |> validate_required([:email])
     |> get_email()
  end
  defp get_email(changeset) do
      case changeset.valid? do
        true ->
          case Usuarios.Repo.get_by(__MODULE__, email: get_field(changeset, :email)) do
            nil -> add_error(changeset, :email, "correo no encontrado")
            usuario -> usuario
          end
        false -> changeset
      end
    end

  def buscar_usuarios() do
    query = from u in Usuarios.User,
    select: u
    Usuarios.Repo.all(query)
  end

  def buscar_usuario(id) do
    query = from u in Usuarios.User,
    where: u.id == ^id,
    select: u
      Usuarios.Repo.one(query)
  end





 end
