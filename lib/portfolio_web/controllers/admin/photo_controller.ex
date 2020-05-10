defmodule PortfolioWeb.Admin.PhotoController do
  use PortfolioWeb, :controller

  alias Portfolio.Galleries
  alias Portfolio.Galleries.Photo

  def index(conn, _params) do
    photos = Galleries.list_photos()
    render(conn, "index.html", photos: photos)
  end

  def new(conn, _params) do
    changeset = Galleries.change_photo(%Photo{order: 9999})
    albums = Galleries.list_albums()
    render(conn, "new.html", changeset: changeset, albums: albums)
  end

  def create(conn, %{"photo" => photo_params}) do
    case Galleries.create_photo(photo_params) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Photo created successfully.")
        |> redirect(to: Routes.admin_photo_path(conn, :show, photo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    photo = Galleries.get_photo!(id)
    render(conn, "show.html", photo: photo)
  end

  def edit(conn, %{"id" => id}) do
    photo = Galleries.get_photo!(id)
    changeset = Galleries.change_photo(photo)
    albums = Galleries.list_albums()
    render(conn, "edit.html", photo: photo, changeset: changeset, albums: albums)
  end

  def update(conn, %{"id" => id, "photo" => photo_params}) do
    photo = Galleries.get_photo!(id)

    case Galleries.update_photo(photo, photo_params) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Photo updated successfully.")
        |> redirect(to: Routes.admin_photo_path(conn, :show, photo))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", photo: photo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    photo = Galleries.get_photo!(id)
    {:ok, _photo} = Galleries.delete_photo(photo)

    conn
    |> put_flash(:info, "Photo deleted successfully.")
    |> redirect(to: Routes.admin_photo_path(conn, :index))
  end
end
