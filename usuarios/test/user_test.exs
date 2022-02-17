defmodule Usuarios.UserTest do
  use Usuarios.DataCase
  alias Usuarios
  alias Usuarios.User


  describe "crear usuario" do

    test "crear usuario successfully" do
      changeset = Usuarios.User.crear_usuario_changeset(%{"name" => "Brian", "email" => "brian@cordage.io"})
      assert changeset.valid? == true
    end

    test "crear usuario sin email" do
      changeset = Usuarios.User.crear_usuario_changeset(%{"name" => "brian", email: ""})
      assert changeset.valid? == false
    end

    test "crear usuario vacio" do
      changeset = Usuarios.User.crear_usuario_changeset(%{"name" => "", "email" => ""})
      assert changeset.valid? == false
    end

    test "crear usuario sin nombre" do
      changeset = Usuarios.User.crear_usuario_changeset(%{"name" => "", "email" => "brian@cordage.io"})
      assert changeset.valid? == false
    end
   end


  describe "actualizar usuario" do
    setup do
      usuario = %Usuarios.User{}
      usuario_changeset =Usuarios.User.crear_usuario_changeset(%{"name" => "Brian", "email" => "brian@cordage.io"})
      guardar_usuario = Usuarios.Repo.insert(usuario_changeset)
      {:ok, user: guardar_usuario}
  end


    test "usuario actualizado", %{user: user}do
      {:ok, usuario_update} =Usuarios.User.actualizar_usuario_changeset(%{"id" => user.id, "name" => "Brian", "email" => "brian@cordage.io"})
      assert not is_nil(usuario_update)
    end

  end

  describe "actualizar password" do
    setup do
      usuario = %Usuarios.User{}
      usuario_changeset =Usuarios.User.crear_usuario_changeset(%{"name" => "Brian", "email" => "brian@cordage.io"})
      guardar_usuario = Usuarios.Repo.insert(usuario_changeset)
      {:ok, user: guardar_usuario}
  end

    test "usuario actualizado", %{user: user}do
      {:ok, password_update} =Usuarios.User.actualizar_password_changeset(%{"id" => user.id, "name" => "Brian" , "password" => "123456@aA"})
      assert not is_nil(password_update)
    end
  end

  describe "eliminar usuario" do
    setup do
      usuario = %Usuarios.User{}
      usuario_changeset =Usuarios.User.crear_usuario_changeset(%{"name" => "Brian", "email" => "brian@cordage.io"})
      guardar_usuario = Usuarios.Repo.insert(usuario_changeset)
      {:ok, user: guardar_usuario}
  end

    test "del user succesfully", %{user: user} do
      {:ok, user_del} = Usuarios.User.eliminar_usuario_changeset(%{"id" => user.id})
      assert not is_nil(user_del)
    end


  end

  describe "mostrar usuario" do
    setup do
      usuario = %Usuarios.User{}
      usuario_changeset =Usuarios.User.crear_usuario_changeset(%{"name" => "Brian", "email" => "brian@cordage.io"})
      guardar_usuario = Usuarios.Repo.insert(usuario_changeset)
      {:ok, user: guardar_usuario}

      # test "get users succesfully", %{user: user} do
      #   changeset = Usuarios.User.buscar_usuario(%{"id" => user.id})
      #   assert changeset.valid? == true
      # end

  end
  end

  describe "mostrar usuarios" do
    setup do
      usuario = %Usuarios.User{}
      usuario_changeset =Usuarios.User.crear_usuario_changeset(%{"name" => "Brian", "email" => "brian@cordage.io"})
      guardar_usuario = Usuarios.Repo.insert(usuario_changeset)
      {:ok, user: guardar_usuario}
  end

    test "get users succesfully" do
      changeset = Usuarios.User.buscar_usuarios()
      assert changeset.valid? == true
    end
  end

 end
