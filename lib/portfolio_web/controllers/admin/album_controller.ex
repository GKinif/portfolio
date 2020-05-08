defmodule PortfolioWeb.Admin.AlbumController do
  use PortfolioWeb, :controller

  alias Portfolio.Galleries
  alias Portfolio.Galleries.Album

  def index(conn, _params) do
    albums = Galleries.list_albums()
    render(conn, "index.html", albums: albums)
  end

  def new(conn, _params) do
    changeset = Galleries.change_album(%Album{visible: true})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"album" => album_params}) do
    case Galleries.create_album(album_params) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album created successfully.")
        |> redirect(to: Routes.admin_album_path(conn, :show, album))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    album = Galleries.get_album!(id)
    render(conn, "show.html", album: album)
  end

  def edit(conn, %{"id" => id}) do
    album = Galleries.get_album!(id)
    changeset = Galleries.change_album(album)
    render(conn, "edit.html", album: album, changeset: changeset)
  end

  def update(conn, %{"id" => id, "album" => album_params}) do
    album = Galleries.get_album!(id)

    case Galleries.update_album(album, album_params) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album updated successfully.")
        |> redirect(to: Routes.admin_album_path(conn, :show, album))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", album: album, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    album = Galleries.get_album!(id)
    {:ok, _album} = Galleries.delete_album(album)

    conn
    |> put_flash(:info, "Album deleted successfully.")
    |> redirect(to: Routes.admin_album_path(conn, :index))
  end
end
