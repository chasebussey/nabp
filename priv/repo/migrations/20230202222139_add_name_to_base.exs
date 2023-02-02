defmodule Nabp.Repo.Migrations.AddNameToBase do
  use Ecto.Migration

  def change do
    alter table("bases") do
      add :name, :string
      remove :ticker
    end
  end
end
