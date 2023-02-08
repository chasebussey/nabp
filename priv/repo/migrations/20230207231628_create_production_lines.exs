defmodule Nabp.Repo.Migrations.CreateProductionLines do
  use Ecto.Migration

  def change do
    create table(:production_lines) do
      add :building_ticker, :string
      add :building_id, references(:buildings, on_delete: :nothing)
      add :num_buildings, :integer
      add :recipes, :map
      add :efficiency, :decimal, default: 1.00
      add :expertise, :string
      add :base_id, references(:bases, on_delete: :delete_all)
    end
  end
end
