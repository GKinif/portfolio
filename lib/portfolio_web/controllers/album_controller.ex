defmodule PortfolioWeb.AlbumController do
  use PortfolioWeb, :controller

  alias Portfolio.Galleries
  alias Portfolio.Galleries.Album

  def index(conn, _params) do
    albums = Galleries.list_albums()
    render(conn, "index.html", albums: albums)
  end

  def show(conn, %{"id" => id}) do
    album = Galleries.get_album!(id)
    render(conn, "show.html", album: album)
  end
end
