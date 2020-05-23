defmodule PortfolioWeb.Admin.PhotoControllerTest do
  use PortfolioWeb.ConnCase

  alias Portfolio.Galleries
  alias Portfolio.Accounts

  @valid_email Application.fetch_env!(:portfolio, :accepted_user_email)
  @user_attrs %{email: @valid_email, username: "some name", picture: "some picture"}
  @album_attrs %{featured: true, long_description: "some long_description", name: "some name", order: 42, password: "some password", short_description: "some short_description", visible: true}

  @create_attrs %{alt: "some alt", description: "some description", featured: true, order: 42}
  @update_attrs %{alt: "some updated alt", description: "some updated description", featured: false, order: 43}
  @invalid_attrs %{alt: nil, description: nil, featured: nil, order: nil}

  def fixture(:album) do
    {:ok, album} = Galleries.create_album(@album_attrs)
    album
  end

  def fixture(:photo) do
    album = fixture(:album)
    {:ok, photo} = Galleries.create_photo(Map.put(@create_attrs, :album_id, album.id))
    {album, photo}
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    user
  end

  describe "authentication" do
    setup [:create_photo]

    @tag :skip
    test "prevent accessing admin photo when user is not authenticated", %{conn: conn, album: album, photo: photo} do
      conn = get(conn, Routes.admin_album_photo_path(conn, :show, album, photo))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "new photo" do
    setup [:create_user, :create_album]

    @tag :skip
    test "renders form", %{conn: conn, user: user, album: album} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> Plug.Conn.assign(:albums, [])
        |> get(Routes.admin_album_photo_path(conn, :new, album))

      assert html_response(conn, 200) =~ "New Photo"
    end
  end

  describe "create photo" do
    setup [:create_user, :create_album]

    @tag :skip
    test "redirects to show when data is valid", %{conn: conn, user: user, album: album} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> post(Routes.admin_album_photo_path(conn, :create, album), photo: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_album_photo_path(conn, :show, album, id)

      conn = get(conn, Routes.admin_album_photo_path(conn, :show, album, id))
      assert html_response(conn, 200) =~ "Show Photo"
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, user: user, album: album} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> post(Routes.admin_album_photo_path(conn, :create, album), photo: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Photo"
    end
  end

  describe "edit photo" do
    setup [:create_photo, :create_user]

    @tag :skip
    test "renders form for editing chosen photo", %{conn: conn, album: album, photo: photo, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> get(Routes.admin_album_photo_path(conn, :edit, album, photo))

      assert html_response(conn, 200) =~ "Edit Photo"
    end
  end

  describe "update photo" do
    setup [:create_photo, :create_user]

    @tag :skip
    test "redirects when data is valid", %{conn: conn, album: album, photo: photo, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> put(Routes.admin_album_photo_path(conn, :update, album, photo), photo: @update_attrs)

      assert redirected_to(conn) == Routes.admin_album_photo_path(conn, :show, album, photo)

      conn = get(conn, Routes.admin_album_photo_path(conn, :show, album, photo))
      assert html_response(conn, 200) =~ "some updated alt"
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, album: album, photo: photo, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> put(Routes.admin_album_photo_path(conn, :update, album, photo), photo: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Photo"
    end
  end

  describe "delete photo" do
    setup [:create_photo, :create_user]

    @tag :skip
    test "deletes chosen photo", %{conn: conn, album: album, photo: photo, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> delete(Routes.admin_album_photo_path(conn, :delete, album, photo))

      assert redirected_to(conn) == Routes.admin_album_photo_path(conn, :index, album)
      assert_error_sent 404, fn ->
        get(conn, Routes.admin_album_photo_path(conn, :show, album, photo))
      end
    end
  end

  defp create_album(_) do
    album = fixture(:album)
    %{album: album}
  end

  defp create_photo(_) do
    {album, photo} = fixture(:photo)
    %{album: album, photo: photo}
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
