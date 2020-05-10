defmodule Portfolio.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :image, :string
      add :description, :string, size: 100
      add :alt, :string
      add :order, :integer, default: 9999
      add :featured, :boolean, default: false, null: false
      add :album_id, references(:albums, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:photos, [:album_id])
  end
end
