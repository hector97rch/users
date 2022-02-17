defmodule UsuariosWeb.PageController do
  use UsuariosWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
