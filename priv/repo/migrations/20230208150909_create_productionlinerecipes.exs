defmodule Nabp.Repo.Migrations.CreateProductionlinerecipes do
  use Ecto.Migration

  def change do
    create table(:production_lines_recipes, primary_key: false) do
      add :production_line_id, references(:production_lines, on_delete: :nothing), null: false, primary_key: true
      add :recipe_id, references(:recipes, on_delete: :nothing), null: false, primary_key: true
      add :order_size, :integer, null: false, default: 1

      timestamps()
    end

    create index(:production_lines_recipes, [:production_line_id])
    create index(:production_lines_recipes, [:recipe_id])
  end
end
