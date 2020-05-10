defmodule Portfolio.Galleries.Album do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema
  alias Portfolio.Galleries.Photo

  schema "albums" do
    field :name, :string
    field :cover, Portfolio.Uploaders.AlbumCoverUploader.Type
    field :short_description, :string
    field :long_description, :string
    field :visible, :boolean, default: false
    field :featured, :boolean, default: false
    field :order, :integer
    field :password, :string

    has_many :photos, Photo

    timestamps()
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:name, :short_description, :long_description, :visible, :password, :order, :featured])
    |> cast_attachments(attrs, [:cover])
    |> validate_required([:name])
  end
end
