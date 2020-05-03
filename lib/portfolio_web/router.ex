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
  end

  pipeline :protected do
    plug PortfolioWeb.Plugs.RequestAuthenticated
  end

  scope "/", PortfolioWeb do
    pipe_through :browser

    get("/session/new", SessionController, :new)
    delete("/session", SessionController, :delete)

    get "/", PageController, :index
    live_dashboard "/dashboard", metrics: PortfolioWeb.Telemetry
  end

  scope "/auth", PortfolioWeb do
    pipe_through(:browser)

    get("/:provider", SessionController, :request)
    get("/:provider/callback", SessionController, :callback)
  end

  scope "/admin", PortfolioWeb do
    pipe_through [:browser, :protected]

    resources "/users", UserController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", PortfolioWeb do
  #   pipe_through :api
  # end
end
