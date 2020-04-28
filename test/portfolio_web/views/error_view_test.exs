defmodule PortfolioWeb.ErrorViewTest do
  use PortfolioWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  #test "renders 404.html", %{conn: conn} do
   # assert render_to_string(PortfolioWeb.ErrorView, "404.html", conn: conn) =~ "Oops"
    # PortfolioWeb.ErrorView("404.html", conn: build_conn(:get, "/"))
  # end

  test "renders 500.html" do
    assert render_to_string(PortfolioWeb.ErrorView, "500.html", []) == "Internal Server Error"
  end
end
