defmodule Nabp.Bases.ProductionLine do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nabp.ProductionLineRecipe

  @derive Jason.Encoder

  schema "production_lines" do
    field :num_buildings, :integer
    field :building_ticker, :string
    field :efficiency, :decimal, default: 1.00
    field :expertise, Ecto.Enum, values: [:agriculture, :chemistry, :construction, :electronics,
                                          :food_industries, :fuel_refining, :manufacturing,
                                          :metallurgy, :resource_extraction]
    many_to_many :recipes, Nabp.Recipes.Recipe, join_through: ProductionLineRecipe
    belongs_to :base, Nabp.Bases.Base
    belongs_to :building, Nabp.Buildings.Building

    timestamps()
  end

  def changeset(production_line, attrs) do
    production_line
    |> cast(attrs, [:building_ticker, :num_buildings, :efficiency, :expertise, :base_id])
    |> cast_assoc(:recipes)
    |> validate_required([:building_ticker, :num_buildings, :expertise])
  end

end
