defmodule PortfolioWeb.PageController do
  use PortfolioWeb, :controller
  alias Portfolio.Galleries

  def index(conn, _params) do
    :telemetry.execute(
      [:portfolio, :render],
      %{controller: "PageController"},
      %{controller: "PageController", action: "index"}
    )
    albums = Galleries.list_featured_albums()

    render(conn, "index.html", albums: albums)
  end
end
