defmodule Nabp.Repo.Migrations.CreateBuildings do
  use Ecto.Migration

  def change do
    create table(:buildings) do
      add :ticker, :string
      add :name, :string
      add :expertise, :string
      add :pioneers, :integer
      add :settlers, :integer
      add :technicians, :integer
      add :engineers, :integer
      add :scientists, :integer
      add :area_cost, :integer

      timestamps()
    end
  end
end
