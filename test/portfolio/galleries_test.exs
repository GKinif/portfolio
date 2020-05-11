defmodule Portfolio.GalleriesTest do
  use Portfolio.DataCase

  alias Portfolio.Galleries

  describe "albums" do
    alias Portfolio.Galleries.Album

    @valid_attrs %{featured: true, long_description: "some long_description", name: "some name", order: 42, password: "some password", short_description: "some short_description", visible: true}
    @update_attrs %{featured: false, long_description: "some updated long_description", name: "some updated name", order: 43, password: "some updated password", short_description: "some updated short_description", visible: false}
    @invalid_attrs %{featured: nil, long_description: nil, name: nil, order: nil, password: nil, short_description: nil, visible: nil}

    def album_fixture(attrs \\ %{}) do
      {:ok, album} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Galleries.create_album()

      album
    end

    test "list_albums/0 returns all albums" do
      album = album_fixture()
      assert Galleries.list_albums() == [album]
    end

    test "get_album!/1 returns the album with given id" do
      album = album_fixture()
      assert Galleries.get_album!(album.id) == Map.put(album, :photos, [])
    end

    test "create_album/1 with valid data creates a album" do
      assert {:ok, %Album{} = album} = Galleries.create_album(@valid_attrs)
      assert album.featured == true
      assert album.long_description == "some long_description"
      assert album.name == "some name"
      assert album.order == 42
      assert album.password == "some password"
      assert album.short_description == "some short_description"
      assert album.visible == true
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Galleries.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album" do
      album = album_fixture()
      assert {:ok, %Album{} = album} = Galleries.update_album(album, @update_attrs)
      assert album.featured == false
      assert album.long_description == "some updated long_description"
      assert album.name == "some updated name"
      assert album.order == 43
      assert album.password == "some updated password"
      assert album.short_description == "some updated short_description"
      assert album.visible == false
    end

    test "update_album/2 with invalid data returns error changeset" do
      album = album_fixture()
      assert {:error, %Ecto.Changeset{}} = Galleries.update_album(album, @invalid_attrs)
      assert Map.put(album, :photos, []) == Galleries.get_album!(album.id)
    end

    test "delete_album/1 deletes the album" do
      album = album_fixture()
      assert {:ok, %Album{}} = Galleries.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Galleries.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset" do
      album = album_fixture()
      assert %Ecto.Changeset{} = Galleries.change_album(album)
    end
  end

  describe "photos" do
    alias Portfolio.Galleries.Photo

    @valid_attrs %{alt: "some alt", description: "some description", featured: true, image: "some image", order: 42}
    @update_attrs %{alt: "some updated alt", description: "some updated description", featured: false, image: "some updated image", order: 43}
    @invalid_attrs %{alt: nil, description: nil, featured: nil, image: nil, order: nil}

    def photo_fixture(attrs \\ %{}) do
      {:ok, photo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Galleries.create_photo()

      photo
    end

    @tag :skip
    test "list_photos/0 returns all photos" do
      photo = photo_fixture()
      assert Galleries.list_photos() == [photo]
    end

    @tag :skip
    test "get_photo!/1 returns the photo with given id" do
      photo = photo_fixture()
      assert Galleries.get_photo!(photo.id) == photo
    end

    @tag :skip
    test "create_photo/1 with valid data creates a photo" do
      assert {:ok, %Photo{} = photo} = Galleries.create_photo(@valid_attrs)
      assert photo.alt == "some alt"
      assert photo.description == "some description"
      assert photo.featured == true
      assert photo.image == "some image"
      assert photo.order == 42
    end

    @tag :skip
    test "create_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Galleries.create_photo(@invalid_attrs)
    end

    @tag :skip
    test "update_photo/2 with valid data updates the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{} = photo} = Galleries.update_photo(photo, @update_attrs)
      assert photo.alt == "some updated alt"
      assert photo.description == "some updated description"
      assert photo.featured == false
      assert photo.image == "some updated image"
      assert photo.order == 43
    end

    @tag :skip
    test "update_photo/2 with invalid data returns error changeset" do
      photo = photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Galleries.update_photo(photo, @invalid_attrs)
      assert photo == Galleries.get_photo!(photo.id)
    end

    @tag :skip
    test "delete_photo/1 deletes the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{}} = Galleries.delete_photo(photo)
      assert_raise Ecto.NoResultsError, fn -> Galleries.get_photo!(photo.id) end
    end

    @tag :skip
    test "change_photo/1 returns a photo changeset" do
      photo = photo_fixture()
      assert %Ecto.Changeset{} = Galleries.change_photo(photo)
    end
  end
end
