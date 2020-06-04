defmodule PortfolioWeb.Admin.PhotoView do
  use PortfolioWeb, :view

  def render("scripts.new.html", assigns) do
    ~E|<script src="<%= Routes.static_path(assigns[:conn], "/js/multiEditor.js") %>"></script>|
  end
  def render("styles.new.html", assigns) do
    ~E|<link rel="stylesheet" href="<%= Routes.static_path(assigns[:conn], "/css/multiEditor.css") %>"/>|
  end
  def render("scripts.edit.html", assigns) do
    ~E|<script src="<%= Routes.static_path(assigns[:conn], "/js/multiEditor.js") %>"></script>|
  end
  def render("styles.edit.html", assigns) do
    ~E|<link rel="stylesheet" href="<%= Routes.static_path(assigns[:conn], "/css/multiEditor.css") %>"/>|
  end

  def render("file-upload-success.json", %{photo: photo}) do
    %{upload: render_one(photo, PortfolioWeb.Admin.PhotoView, "photo.json")}
  end
  def render("file-upload-error.json", _assigns) do
    %{error: ["test"]}
  end

  def render("photo.json", %{photo: photo}) do
    %{
      album_id: photo.album_id,
      alt: photo.alt,
      description: photo.description,
      featured: photo.featured,
      id: photo.id,
      image: Portfolio.Uploaders.PhotoUploader.url({photo.image, photo}, :original),
      order: photo.order,
    }
  end
end
