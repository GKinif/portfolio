defmodule PortfolioWeb.AlbumView do
  use PortfolioWeb, :view
  def render("scripts.html", assigns) do
    ~E|<script src="<%= Routes.static_path(assigns[:conn], "/js/gallery.js") %>"></script>|
  end

  def render("styles.html", assigns) do
    ~E|<link rel="stylesheet" href="<%= Routes.static_path(assigns[:conn], "/css/gallery.css") %>"/>|
  end
end
