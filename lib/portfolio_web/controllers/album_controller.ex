defmodule PortfolioWeb.AlbumController do
  use PortfolioWeb, :controller

  alias Portfolio.Galleries

  def index(conn, _params) do
    albums = Galleries.list_visible_albums()
    render(conn, "index.html", albums: albums)
  end

  def show(conn, %{"id" => id}) do
    album = Galleries.get_album!(id)
    render(conn, "show.html", album: album)
  end
end
