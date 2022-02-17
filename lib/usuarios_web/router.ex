defmodule UsuariosWeb.Router do
  use UsuariosWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {UsuariosWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug,
    send_preflight_response?: false,
    origin: [
      "http://40.69.134.65:3000"
    ]
    plug :accepts, ["json"]
  end
# coveralls-ignore-start
  # pipeline :autenticated do
  #   plug UsuariosWeb.Plugs.TokenPlug
  # end

  pipeline :auth do
    plug Usuarios.Guardian.AuthPipeline
  end
# coveralls-ignore-stop

  scope "/", UsuariosWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
   scope "/api", UsuariosWeb do
     pipe_through :api
     # coveralls-ignore-start
     #---------------------cors--------------------
     options "/", OptionsController, :options
     options "/users", OptionsController, :options
     options "/users/:id", OptionsController, :options
     options "/users/password/:id", OptionsController, :options
     options "/users/rpassword/:id", OptionsController, :options
     options "/session/new", OptionsController, :options
     options "/session/refresh", OptionsController, :options
     options "/session/delete", OptionsController, :options
      # coveralls-ignore-stop
      #-------------------fin CORS------------------------

     get "/users/", UserController, :show_usuarios
     get "/users/:id", UserController, :show_usuario
     post "/users", UserController, :crear_usuario
     delete "/users/:id", UserController, :delete_usuario
     put "/users/:id", UserController, :update_usuario
     put "/users/password/:id", UserController, :update_password
     post "/users/rpassword/:id", UserController, :reset_password
     #------session----------------
     post "/session/new", SessionController, :new
   end

  scope "/api", UsuariosWeb do
    pipe_through [:api, :auth]
    post "/session/refresh", SessionController, :refresh
    post "/session/delete", SessionController, :delete
   end


  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
   # coveralls-ignore-start
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: UsuariosWeb.Telemetry
    end
  end
 # coveralls-ignore-stop
  scope "/api", Usuarios do
    pipe_through :api
    resources "/users", UserController
  end
 # coveralls-ignore-start
  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "usuarios"
      }
    }
  end
   # coveralls-ignore-stop

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
