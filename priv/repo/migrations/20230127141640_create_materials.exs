defmodule Nabp.Repo.Migrations.CreateMaterials do
  use Ecto.Migration

  def change do
    create table(:materials) do
      add :name, :string
      add :ticker, :string
      add :category_name, :string
      add :weight, :float
      add :volume, :float

      timestamps()
    end
  end
end
