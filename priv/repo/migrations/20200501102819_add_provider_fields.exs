defmodule Portfolio.Repo.Migrations.AddProviderFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :picture, :string
    end
  end
end
