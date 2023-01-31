defmodule Nabp.Bases.ProductionLine do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  embedded_schema do
    field :num_buildings, :integer
    field :building_ticker, :string
    field :recipes, {:array, :map}
    field :efficiency, :float, default: 1.00
  end

  def changeset(production_line, attrs) do
    production_line
    |> cast(attrs, [:building_ticker, :num_buildings, :recipes, :efficiency])
    |> validate_required([:building_ticker, :num_buildings])
  end
end
