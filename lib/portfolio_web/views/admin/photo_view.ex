defmodule PortfolioWeb.Admin.PhotoView do
  use PortfolioWeb, :view

  def render("scripts.new.html", assigns) do
    ~E|<script src="<%= Routes.static_path(assigns[:conn], "/js/editor.js") %>"></script>|
  end
  def render("styles.new.html", assigns) do
    ~E|<link rel="stylesheet" href="<%= Routes.static_path(assigns[:conn], "/css/editor.css") %>"/>|
  end

  def render("scripts.edit.html", assigns) do
    ~E|<script src="<%= Routes.static_path(assigns[:conn], "/js/editor.js") %>"></script>|
  end
  def render("styles.edit.html", assigns) do
    ~E|<link rel="stylesheet" href="<%= Routes.static_path(assigns[:conn], "/css/editor.css") %>"/>|
  end

  def render("scripts.index.html", assigns) do
    ~E|<script src="<%= Routes.static_path(assigns[:conn], "/js/admin.js") %>"></script>|
  end
  def render("styles.index.html", assigns) do
    ~E|<link rel="stylesheet" href="<%= Routes.static_path(assigns[:conn], "/css/admin.css") %>"/>|
  end
end
