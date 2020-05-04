defmodule Portfolio.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :name, :string, null: false
      add :cover, :string
      add :short_description, :string
      add :long_description, :text
      add :visible, :boolean, default: true, null: false
      add :featured, :boolean, default: false, null: false
      add :order, :integer, default: 9999
      add :password, :string

      timestamps()
    end

    create unique_index(:albums, [:name])
  end
end
