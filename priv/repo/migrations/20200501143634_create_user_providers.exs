defmodule Portfolio.Repo.Migrations.CreateUserProviders do
  use Ecto.Migration

  def change do
    create table(:user_providers) do
      add :provider, :string
      add :uid, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:user_providers, [:uid, :provider])
  end
end
