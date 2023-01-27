defmodule Nabp.Bases.ProductionLine do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :buildings, {:array, :map}
    field :recipes, {:array, :map}
    field :efficiency, :float, default: 1.00
  end

  def changeset(production_line, attrs) do
    production_line
    |> cast(attrs, [:buildings, :recipes, :efficiency])
    |> validate_required([:buildings])
  end
end
