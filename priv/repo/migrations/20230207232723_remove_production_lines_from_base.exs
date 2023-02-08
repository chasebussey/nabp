defmodule Nabp.Repo.Migrations.RemoveProductionLinesFromBase do
  use Ecto.Migration

  def change do
    alter table(:bases) do
      remove :production_lines
    end
  end
end
