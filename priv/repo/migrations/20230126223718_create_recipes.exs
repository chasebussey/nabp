defmodule Nabp.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string
      add :inputs, :map
      add :outputs, :map
      add :duration_ms, :integer
      add :building_id, references(:buildings, on_delete: :nothing)

      timestamps()
    end

    create index(:recipes, [:building_id])
  end
end
