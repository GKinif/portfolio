defmodule PortfolioWeb.AlbumControllerTest do
  use PortfolioWeb.ConnCase

  alias Portfolio.Galleries

  @create_attrs %{featured: true, long_description: "some long_description", name: "some name", order: 42, password: "some password", short_description: "some short_description", visible: true}

  def fixture(:album) do
    {:ok, album} = Galleries.create_album(@create_attrs)
    album
  end

  describe "index" do
    setup [:create_album]

    test "lists all albums", %{conn: conn} do
      conn = get(conn, Routes.album_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Albums"
    end
  end

  defp create_album(_) do
    album = fixture(:album)
    %{album: album}
  end
end
