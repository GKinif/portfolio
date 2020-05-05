defmodule PortfolioWeb.LayoutView do
  use PortfolioWeb, :view

  def add_active_class(conn, path, active_class, class) do
    if path == Phoenix.Controller.current_path(conn, %{}) do
      class <> " #{active_class}"
    else
      class
    end
  end
end
