defmodule Nabp.Repo.Migrations.CreateBases do
  use Ecto.Migration

  def change do
    create table(:bases) do
      add :ticker, :string
      add :experts, :map
      add :permits, :integer
      add :available_area, :integer
      add :used_area, :integer
      add :cogc, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :production_lines, :map

      timestamps()
    end

    create index(:bases, [:user_id])
  end
end
