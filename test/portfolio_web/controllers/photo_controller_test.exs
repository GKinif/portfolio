defmodule PortfolioWeb.PhotoControllerTest do
  use PortfolioWeb.ConnCase

  alias Portfolio.Galleries

  @create_attrs %{alt: "some alt", description: "some description", featured: true, image: "some image", order: 42}
  @update_attrs %{alt: "some updated alt", description: "some updated description", featured: false, image: "some updated image", order: 43}
  @invalid_attrs %{alt: nil, description: nil, featured: nil, image: nil, order: nil}

  def fixture(:photo) do
    {:ok, photo} = Galleries.create_photo(@create_attrs)
    photo
  end

  describe "index" do
    test "lists all photos", %{conn: conn} do
      conn = get(conn, Routes.photo_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Photos"
    end
  end

  describe "new photo" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.photo_path(conn, :new))
      assert html_response(conn, 200) =~ "New Photo"
    end
  end

  describe "create photo" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.photo_path(conn, :create), photo: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.photo_path(conn, :show, id)

      conn = get(conn, Routes.photo_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Photo"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.photo_path(conn, :create), photo: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Photo"
    end
  end

  describe "edit photo" do
    setup [:create_photo]

    test "renders form for editing chosen photo", %{conn: conn, photo: photo} do
      conn = get(conn, Routes.photo_path(conn, :edit, photo))
      assert html_response(conn, 200) =~ "Edit Photo"
    end
  end

  describe "update photo" do
    setup [:create_photo]

    test "redirects when data is valid", %{conn: conn, photo: photo} do
      conn = put(conn, Routes.photo_path(conn, :update, photo), photo: @update_attrs)
      assert redirected_to(conn) == Routes.photo_path(conn, :show, photo)

      conn = get(conn, Routes.photo_path(conn, :show, photo))
      assert html_response(conn, 200) =~ "some updated alt"
    end

    test "renders errors when data is invalid", %{conn: conn, photo: photo} do
      conn = put(conn, Routes.photo_path(conn, :update, photo), photo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Photo"
    end
  end

  describe "delete photo" do
    setup [:create_photo]

    test "deletes chosen photo", %{conn: conn, photo: photo} do
      conn = delete(conn, Routes.photo_path(conn, :delete, photo))
      assert redirected_to(conn) == Routes.photo_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.photo_path(conn, :show, photo))
      end
    end
  end

  defp create_photo(_) do
    photo = fixture(:photo)
    %{photo: photo}
  end
end
