defmodule PortfolioWeb.AlbumView do
  use PortfolioWeb, :view
  def render("scripts.show.html", assigns) do
    ~E|<script src="<%= Routes.static_path(assigns[:conn], "/js/gallery.js") %>"></script>|
  end

  def render("styles.show.html", assigns) do
    ~E|<link rel="stylesheet" href="<%= Routes.static_path(assigns[:conn], "/css/gallery.css") %>"/>|
  end

  def flex_order(index) do
    if rem(index, 2) == 0 do
      "sm:order-last cut-left sm:border-r"
    else
      "cut-right sm:border-l"
    end
  end
end
