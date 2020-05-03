defmodule PortfolioWeb.Admin.AlbumControllerTest do
  use PortfolioWeb.ConnCase

  alias Portfolio.Galleries

  @create_attrs %{featured: true, long_description: "some long_description", name: "some name", order: 42, password: "some password", short_description: "some short_description", visible: true}
  @update_attrs %{featured: false, long_description: "some updated long_description", name: "some updated name", order: 43, password: "some updated password", short_description: "some updated short_description", visible: false}
  @invalid_attrs %{featured: nil, long_description: nil, name: nil, order: nil, password: nil, short_description: nil, visible: nil}

  def fixture(:album) do
    {:ok, album} = Galleries.create_album(@create_attrs)
    album
  end

  describe "index" do
    test "lists all albums", %{conn: conn} do
      conn = get(conn, Routes.admin_album_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Albums"
    end
  end

  describe "new album" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_album_path(conn, :new))
      assert html_response(conn, 200) =~ "New Album"
    end
  end

  describe "create album" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_album_path(conn, :create), album: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_album_path(conn, :show, id)

      conn = get(conn, Routes.admin_album_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Album"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_album_path(conn, :create), album: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Album"
    end
  end

  describe "edit album" do
    setup [:create_album]

    test "renders form for editing chosen album", %{conn: conn, album: album} do
      conn = get(conn, Routes.admin_album_path(conn, :edit, album))
      assert html_response(conn, 200) =~ "Edit Album"
    end
  end

  describe "update album" do
    setup [:create_album]

    test "redirects when data is valid", %{conn: conn, album: album} do
      conn = put(conn, Routes.admin_album_path(conn, :update, album), album: @update_attrs)
      assert redirected_to(conn) == Routes.admin_album_path(conn, :show, album)

      conn = get(conn, Routes.admin_album_path(conn, :show, album))
      assert html_response(conn, 200) =~ "some updated long_description"
    end

    test "renders errors when data is invalid", %{conn: conn, album: album} do
      conn = put(conn, Routes.admin_album_path(conn, :update, album), album: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Album"
    end
  end

  describe "delete album" do
    setup [:create_album]

    test "deletes chosen album", %{conn: conn, album: album} do
      conn = delete(conn, Routes.admin_album_path(conn, :delete, album))
      assert redirected_to(conn) == Routes.admin_album_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.admin_album_path(conn, :show, album))
      end
    end
  end

  defp create_album(_) do
    album = fixture(:album)
    %{album: album}
  end
end
