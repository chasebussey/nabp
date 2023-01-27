defmodule Nabp.Repo.Migrations.AddFioApiKeyToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :fio_api_key, :string
    end
  end
end
