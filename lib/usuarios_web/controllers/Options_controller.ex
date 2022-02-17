defmodule UsuariosWeb.OptionsController do
  use UsuariosWeb, :controller
 # coveralls-ignore-start
  def options(conn, _params) do
    conn
      |> resp(204, "")
      |> put_resp_header(
        "acces-control-allow-headers",
        "Authorization, Content-Type, Accept, Origon, User-Agent, DNT, Cache-Control, X-Mx-ReqToken, Keep-Alive, X-Requested-With, If-Modified-Since, X-CSRF-Token,access-control-allow-origin"
      )
      |> send_resp()
  end
 # coveralls-ignore-stop
end
