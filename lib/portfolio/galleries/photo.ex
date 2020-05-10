defmodule Portfolio.Galleries.Photo do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema
  alias Portfolio.Galleries.Album

  schema "photos" do
    field :alt, :string
    field :description, :string
    field :featured, :boolean, default: false
    field :image, Portfolio.Uploaders.PhotoUploader.Type
    field :order, :integer

    belongs_to :album, Album

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:description, :alt, :order, :featured, :album_id])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:album_id])
  end
end
