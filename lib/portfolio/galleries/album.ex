defmodule Portfolio.Galleries.Album do
  use Ecto.Schema
  import Ecto.Changeset

  schema "albums" do
    field :featured, :boolean, default: false
    field :long_description, :string
    field :name, :string
    field :cover, :string
    field :order, :integer
    field :password, :string
    field :short_description, :string
    field :visible, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:name, :short_description, :long_description, :visible, :password, :order, :featured, :cover])
    |> validate_required([:name, :cover, :visible, :featured])
  end
end
