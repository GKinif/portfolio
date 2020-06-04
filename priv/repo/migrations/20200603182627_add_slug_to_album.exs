defmodule Portfolio.Repo.Migrations.AddSlugToAlbum do
  use Ecto.Migration
  import Ecto.Query

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";")

    alter table(:albums) do
      add :slug, :string, null: false, default: fragment("uuid_generate_v4()")
    end

    create unique_index(:albums, [:slug])
  end
end
