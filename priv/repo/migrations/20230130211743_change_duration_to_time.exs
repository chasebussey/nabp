defmodule Nabp.Repo.Migrations.ChangeDurationToTime do
  use Ecto.Migration

  def change do
    rename table("recipes"), :duration_ms, to: :time_ms
  end
end
