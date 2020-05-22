defmodule PortfolioWeb.Admin.AlbumView do
  use PortfolioWeb, :view

  def render("scripts.index.html", assigns) do
    ~E|<script src="<%= Routes.static_path(assigns[:conn], "/js/admin.js") %>"></script>|
  end
  def render("styles.index.html", assigns) do
    ~E|<link rel="stylesheet" href="<%= Routes.static_path(assigns[:conn], "/css/admin.css") %>"/>|
  end
end
