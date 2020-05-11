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
    {:ok, user} = Galleries.create_album(@album_attrs)
    user
  end

  def fixture(:photo) do
    album = fixture(:album)
    {:ok, photo} = Galleries.create_photo(Map.put(@create_attrs, :album_id, album.id))
    photo
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    user
  end

  describe "authentication" do
    @tag :skip
    test "prevent accessing admin photo when user is not authenticated", %{conn: conn} do
      conn = get(conn, Routes.admin_photo_path(conn, :index))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "index" do
    setup [:create_user]

    @tag :skip
    test "lists all photos", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> get(Routes.admin_photo_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Photos"
    end
  end

  describe "new photo" do
    setup [:create_user]

    @tag :skip
    test "renders form", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> Plug.Conn.assign(:albums, [])
        |> get(Routes.admin_photo_path(conn, :new))

      assert html_response(conn, 200) =~ "New Photo"
    end
  end

  describe "create photo" do
    setup [:create_user]

    @tag :skip
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> post(Routes.admin_photo_path(conn, :create), photo: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_photo_path(conn, :show, id)

      conn = get(conn, Routes.admin_photo_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Photo"
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> post(Routes.admin_photo_path(conn, :create), photo: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Photo"
    end
  end

  describe "edit photo" do
    setup [:create_photo, :create_user]

    @tag :skip
    test "renders form for editing chosen photo", %{conn: conn, photo: photo, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> get(Routes.admin_photo_path(conn, :edit, photo))

      assert html_response(conn, 200) =~ "Edit Photo"
    end
  end

  describe "update photo" do
    setup [:create_photo, :create_user]

    @tag :skip
    test "redirects when data is valid", %{conn: conn, photo: photo, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> put(Routes.admin_photo_path(conn, :update, photo), photo: @update_attrs)

      assert redirected_to(conn) == Routes.admin_photo_path(conn, :show, photo)

      conn = get(conn, Routes.admin_photo_path(conn, :show, photo))
      assert html_response(conn, 200) =~ "some updated alt"
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, photo: photo, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> put(Routes.admin_photo_path(conn, :update, photo), photo: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Photo"
    end
  end

  describe "delete photo" do
    setup [:create_photo, :create_user]

    @tag :skip
    test "deletes chosen photo", %{conn: conn, photo: photo, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> delete(Routes.admin_photo_path(conn, :delete, photo))

      assert redirected_to(conn) == Routes.admin_photo_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.admin_photo_path(conn, :show, photo))
      end
    end
  end

  defp create_photo(_) do
    photo = fixture(:photo)
    %{photo: photo}
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
