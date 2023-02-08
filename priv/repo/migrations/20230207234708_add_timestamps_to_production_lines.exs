defmodule Nabp.Repo.Migrations.AddTimestampsToProductionLines do
  use Ecto.Migration

  def change do
    alter table(:production_lines) do
      timestamps
    end
  end
end
