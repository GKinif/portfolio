defmodule PortfolioWeb.PageControllerTest do
  use PortfolioWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "class=\"featured-albums\""
  end
end
