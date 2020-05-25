defmodule Portfolio.Galleries do
  @moduledoc """
  The Galleries context.
  """

  import Ecto.Query, warn: false
  alias Portfolio.Repo
  alias Portfolio.Galleries.Album
  alias Portfolio.Galleries.Photo

  @doc """
  Returns the list of albums.

  ## Examples

      iex> list_albums()
      [%Album{}, ...]

  """
  def list_albums do
    Repo.all(Album)
  end

  @doc """
  Returns the list of albums where visible == true.

  ## Examples

      iex> list_albums()
      [%Album{}, ...]

  """
  def list_visible_albums do
    query =
      from a in Album,
         where: a.visible == true,
         order_by: [desc: :updated_at, asc: :name],
         select: a
    Repo.all(query)
  end

  @doc """
  Returns the list of albums where visible == true and featured == true.

  ## Examples

      iex> list_albums()
      [%Album{}, ...]

  """
  def list_featured_albums do
    query =
      from a in Album,
         where: a.visible == true and a.featured == true,
         select: a
    Repo.all(query)
  end

  @doc """
  Gets a single album.

  Raises `Ecto.NoResultsError` if the Album does not exist.

  ## Examples

      iex> get_album!(123)
      %Album{}

      iex> get_album!(456)
      ** (Ecto.NoResultsError)

  """
  def get_album!(id), do: Repo.get!(Album, id) |> Repo.preload(:photos)

  @doc """
  Creates a album.

  ## Examples

      iex> create_album(%{field: value})
      {:ok, %Album{}}

      iex> create_album(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_album(attrs \\ %{}) do
    attrs_without_cover = Map.delete(attrs, "cover")

    with {:ok, album} <- %Album{}
    |> Album.changeset(attrs_without_cover)
    |> Repo.insert() do
      if Map.has_key?(attrs, "cover") do
        attrs_cover = Map.take(attrs, ["cover"])
        update_album(album, attrs_cover)
      else
        {:ok, album}
      end
    end
  end

  @doc """
  Updates a album.

  ## Examples

      iex> update_album(album, %{field: new_value})
      {:ok, %Album{}}

      iex> update_album(album, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_album(%Album{} = album, attrs) do
    album
    |> Album.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a album.

  ## Examples

      iex> delete_album(album)
      {:ok, %Album{}}

      iex> delete_album(album)
      {:error, %Ecto.Changeset{}}

  """
  def delete_album(%Album{} = album) do
    with {:ok, _} <- delete_album_directory(album) do
      Repo.delete(album)
    else
      error -> error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking album changes.

  ## Examples

      iex> change_album(album)
      %Ecto.Changeset{data: %Album{}}

  """
  def change_album(%Album{} = album, attrs \\ %{}) do
    Album.changeset(album, attrs)
  end

  @doc """
  Returns the list of photos.

  ## Examples

      iex> list_photos()
      [%Photo{}, ...]

  """
  def list_photos do
    Repo.all(Photo)
  end

  def list_featured_photos do
    query =
      from p in Photo,
           where: p.featured == true,
           select: p
    Repo.all(query)
  end

  @doc """
  Gets a single photo.

  Raises `Ecto.NoResultsError` if the Photo does not exist.

  ## Examples

      iex> get_photo!(123)
      %Photo{}

      iex> get_photo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_photo!(id), do: Repo.get!(Photo, id)

  @doc """
  Creates a photo.

  ## Examples

      iex> create_photo(%{field: value})
      {:ok, %Photo{}}

      iex> create_photo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_photo(attrs \\ %{}) do
    attrs_without_image = Map.delete(attrs, "image")

    with {:ok, photo} <- %Photo{}
    |> Photo.changeset(attrs_without_image)
    |> Repo.insert() do
      if Map.has_key?(attrs, "image") do
        attrs_image = Map.take(attrs, ["image"])
        update_photo(photo, attrs_image)
      else
        {:ok, photo}
      end
    end
  end

  @doc """
  Updates a photo.

  ## Examples

      iex> update_photo(photo, %{field: new_value})
      {:ok, %Photo{}}

      iex> update_photo(photo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_photo(%Photo{} = photo, attrs) do
    photo
    |> Photo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a photo.

  ## Examples

      iex> delete_photo(photo)
      {:ok, %Photo{}}

      iex> delete_photo(photo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_photo(%Photo{} = photo) do
    case photo.image do
      nil ->
        Repo.delete(photo)
      _ ->
        with :ok <- delete_photo_from_disk(photo) do
          Repo.delete(photo)
        else
          error -> error
        end
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking photo changes.

  ## Examples

      iex> change_photo(photo)
      %Ecto.Changeset{data: %Photo{}}

  """
  def change_photo(%Photo{} = photo, attrs \\ %{}) do
    Photo.changeset(photo, attrs)
  end

  defp delete_album_directory(%Album{} = album), do: File.rm_rf("uploads/albums/#{album.id}")

  defp delete_photo_from_disk(%Photo{} = photo) do
    Portfolio.Uploaders.PhotoUploader.delete({photo.image, photo})
  end
end
