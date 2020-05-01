defmodule PortfolioWeb.PageController do
  use PortfolioWeb, :controller

  def index(conn, _params) do
    :telemetry.execute(
      [:portfolio, :render],
      %{controller: "PageController"},
      %{controller: "PageController", action: "index"}
    )
    render(conn, "index.html")
  end
end
