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
    featured_photos = Galleries.list_featured_photos()
    render(conn, "index.html", albums: albums, featured_photos: featured_photos)
  end
end
