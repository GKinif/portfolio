defmodule PortfolioWeb.Admin.UserControllerTest do
  use PortfolioWeb.ConnCase

  alias Portfolio.Accounts

  @valid_email Application.fetch_env!(:portfolio, :accepted_user_email)

  @create_attrs %{email: @valid_email, username: "some name", picture: "some picture"}
  @update_attrs %{email: @valid_email, username: "some updated name", picture: "some updated picture"}
  @invalid_attrs %{email: nil, username: nil, picture: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "authentication" do
    test "prevent accessing admin user when user is not authenticated", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :index))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "index" do
    setup [:create_user]

    test "lists all users", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> Plug.Conn.assign(:current_user, user)
        |> get(Routes.admin_user_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    @tag :skip
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    @tag :skip
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_user_path(conn, :show, id)

      conn = get(conn, Routes.admin_user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    @tag :skip
    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.admin_user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag :skip
    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.admin_user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.admin_user_path(conn, :show, user)

      conn = get(conn, Routes.admin_user_path(conn, :show, user))
      assert html_response(conn, 200) =~ @valid_email
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.admin_user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    @tag :skip
    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.admin_user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.admin_user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
