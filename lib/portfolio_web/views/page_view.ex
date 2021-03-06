defmodule PortfolioWeb.PageView do
  use PortfolioWeb, :view
  def render("scripts.index.html", assigns) do
    ~E|<script src="<%= Routes.static_path(assigns[:conn], "/js/gallery.js") %>"></script>|
  end

  def render("styles.index.html", assigns) do
    ~E|<link rel="stylesheet" href="<%= Routes.static_path(assigns[:conn], "/css/gallery.css") %>"/>|
  end
end
