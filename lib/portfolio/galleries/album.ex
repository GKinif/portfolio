defmodule Portfolio.Galleries.Album do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema
  alias Portfolio.Galleries.Photo

  schema "albums" do
    field :name, :string
    field :slug, :string
    field :cover, Portfolio.Uploaders.AlbumCoverUploader.Type
    field :short_description, :string
    field :long_description, :string
    field :visible, :boolean, default: false
    field :featured, :boolean, default: false
    field :order, :integer
    field :password, :string

    # Virtual field used to crop thumbnail
    field :thumb_x, :integer, virtual: true
    field :thumb_y, :integer, virtual: true
    field :thumb_size, :integer, virtual: true

    has_many :photos, Photo

    timestamps()
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:name, :slug, :short_description, :long_description, :visible, :password, :order, :featured, :thumb_x, :thumb_y, :thumb_size])
    |> cast_attachments(attrs, [:cover])
    |> validate_required([:name])
    |> slugify_name()
    |> unique_constraint([:name])
  end

  defp slugify_name(changeset) do
    if name = get_change(changeset, :name) do
      put_change(changeset, :slug, Slug.slugify(name))
    else
      changeset
    end
  end
end

#defimpl Phoenix.Param, for: Portfolio.Galleries.Album do
#  def to_param(%{slug: slug}) do
#    "#{slug}"
#  end
#end
