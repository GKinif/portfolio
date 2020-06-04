defmodule PortfolioWeb.Admin.PhotoController do
  use PortfolioWeb, :controller

  alias Portfolio.Galleries
  alias Portfolio.Galleries.Photo

  def new(conn, %{"admin_album_id" => album_id}) do
    album = Galleries.get_album!(album_id)

    changeset = Galleries.change_photo(%Photo{order: 9999})
    render(conn, "new.html", changeset: changeset, album_id: album.id)
  end

  def create(conn, %{"photo" => photo_params, "admin_album_id" => album_id}) do
    album = Galleries.get_album!(album_id)

    case Galleries.create_photo(Map.put(photo_params, "album_id", album.id)) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Photo created successfully.")
        |> redirect(to: Routes.admin_album_photo_path(conn, :show, album, photo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, album_id: album.id)
    end
  end

  def api_upload(conn, params) do
    album = Galleries.get_album!(params["album_id"])

    case Galleries.create_photo(Map.put(params, "album_id", album.id)) do
      {:ok, photo} ->
        render(conn, "file-upload-success.json", photo: photo)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "file-upload-failed.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "admin_album_id" => album_id}) do
    album = Galleries.get_album!(album_id)
    photo = Galleries.get_photo!(id)
    render(conn, "show.html", photo: photo, album: album)
  end

  def edit(conn, %{"id" => id, "admin_album_id" => album_id}) do
    album = Galleries.get_album!(album_id)
    photo = Galleries.get_photo!(id)

    changeset = Galleries.change_photo(photo)
    render(conn, "edit.html", photo: photo, changeset: changeset, album_id: album.id)
  end

  def update(conn, %{"id" => id, "photo" => photo_params, "admin_album_id" => album_id}) do
    album = Galleries.get_album!(album_id)
    photo = Galleries.get_photo!(id)

    case Galleries.update_photo(photo, Map.put(photo_params, "album_id", album.id)) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Photo updated successfully.")
        |> redirect(to: Routes.admin_album_photo_path(conn, :show, album, photo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", photo: photo, changeset: changeset, album_id: album.id)
    end
  end

  def delete(conn, %{"id" => id, "admin_album_id" => album_id}) do
    album = Galleries.get_album!(album_id)
    photo = Galleries.get_photo!(id)
    {:ok, _photo} = Galleries.delete_photo(photo)

    conn
    |> put_flash(:info, "Photo deleted successfully.")
    |> redirect(to: Routes.admin_album_path(conn, :show, album))
  end
end
