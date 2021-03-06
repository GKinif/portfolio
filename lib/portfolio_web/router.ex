defmodule PortfolioWeb.Router do
  use PortfolioWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PortfolioWeb.Plugs.AssignAuthenticatedUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug PortfolioWeb.Plugs.AssignAuthenticatedUser
  end

  pipeline :protected do
    plug PortfolioWeb.Plugs.RequestAuthenticated
  end

  pipeline :protected_api do
    plug PortfolioWeb.Plugs.RequestAuthenticatedApi
  end

  scope "/", PortfolioWeb do
    pipe_through :browser

    get("/session/new", SessionController, :new)
    delete("/session", SessionController, :delete)

    get "/", PageController, :index
    live_dashboard "/dashboard", metrics: PortfolioWeb.Telemetry

    resources "/albums", AlbumController, only: [:index, :show]

  end

  scope "/auth", PortfolioWeb do
    pipe_through(:browser)

    get("/:provider", SessionController, :request)
    get("/:provider/callback", SessionController, :callback)
    post "/:provider/callback", AuthController, :callback
  end

  scope "/admin", PortfolioWeb do
    pipe_through [:browser, :protected]

    resources "/users", Admin.UserController, only: [:index, :show], name: "admin_user"
    resources "/albums", Admin.AlbumController, name: "admin_album" do
      resources "/photos", Admin.PhotoController, except: [:index]
    end
  end

  # Other scopes may use custom stacks.
   scope "/api", PortfolioWeb do
     pipe_through [:api, :protected_api]

     post "/photoupload", Admin.PhotoController, :api_upload
   end
end
