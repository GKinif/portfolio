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
      assert Galleries.get_album!(album.id) == album
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
      assert album == Galleries.get_album!(album.id)
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
end
