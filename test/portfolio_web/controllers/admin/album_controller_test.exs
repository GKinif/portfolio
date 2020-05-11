defmodule PortfolioWeb.Admin.AlbumControllerTest do
  use PortfolioWeb.ConnCase

  alias Portfolio.Galleries
  alias Portfolio.Accounts

  @valid_email Application.fetch_env!(:portfolio, :accepted_user_email)
  @user_attrs %{email: @valid_email, username: "some name", picture: "some picture"}

  @create_attrs %{featured: true, long_description: "some long_description", name: "some name", order: 42, password: "some password", short_description: "some short_description", visible: true}
  @update_attrs %{featured: false, long_description: "some updated long_description", name: "some updated name", order: 43, password: "some updated password", short_description: "some updated short_description", visible: false}
  @invalid_attrs %{featured: nil, long_description: nil, name: nil, order: nil, password: nil, short_description: nil, visible: nil}

  def fixture(:album) do
    {:ok, album} = Galleries.create_album(@create_attrs)
    album
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    user
  end

  describe "authentication" do
    test "prevent accessing admin album when user is not authenticated", %{conn: conn} do
      conn = get(conn, Routes.admin_album_path(conn, :index))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "index" do
    setup [:create_user]

    test "lists all albums", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> get(Routes.admin_album_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Albums"
    end
  end

  describe "new album" do
    setup [:create_user]

    test "renders form", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> get(Routes.admin_album_path(conn, :new))

      assert html_response(conn, 200) =~ "New Album"
    end
  end

  describe "create album" do
    setup [:create_user]

    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> post(Routes.admin_album_path(conn, :create), album: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_album_path(conn, :show, id)

      conn = get(conn, Routes.admin_album_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Album"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> post(Routes.admin_album_path(conn, :create), album: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Album"
    end
  end

  describe "edit album" do
    setup [:create_album, :create_user]

    test "renders form for editing chosen album", %{conn: conn, album: album, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> get(Routes.admin_album_path(conn, :edit, album))

      assert html_response(conn, 200) =~ "Edit #{album.name}"
    end
  end

  describe "update album" do
    setup [:create_album, :create_user]

    test "redirects when data is valid", %{conn: conn, album: album, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> put(Routes.admin_album_path(conn, :update, album), album: @update_attrs)

      assert redirected_to(conn) == Routes.admin_album_path(conn, :show, album)

      conn = get(conn, Routes.admin_album_path(conn, :show, album))
      assert html_response(conn, 200) =~ "some updated long_description"
    end

    test "renders errors when data is invalid", %{conn: conn, album: album, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> put(Routes.admin_album_path(conn, :update, album), album: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit #{album.name}"
    end
  end

  describe "delete album" do
    setup [:create_album, :create_user]

    test "deletes chosen album", %{conn: conn, album: album, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> delete(Routes.admin_album_path(conn, :delete, album))

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

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
