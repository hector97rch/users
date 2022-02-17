defmodule UsuariosWeb.UserView do
  use UsuariosWeb, :view

  def render("usuarios.json", %{usuarios: usuarios}) do
    render_many(usuarios, UsuariosWeb.UserView, "usuario.json", as: :usuario)

  end

  def render("usuario.json", %{usuario: usuario}) do
      %{
          id: usuario.id,
          name: usuario.name,
          email: usuario.email,
          estado: usuario.estado
      }
  end
  def render("idusuario.json", %{usuario: usuario}) do
    %{
        id: usuario.id
    }
end

end
