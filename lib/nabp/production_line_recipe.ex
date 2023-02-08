defmodule Nabp.ProductionLineRecipe do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "production_lines_recipes" do

    belongs_to :production_line, Nabp.Bases.ProductionLine, primary_key: true
    belongs_to :recipe, Nabp.Recipes.Recipe, primary_key: true
    field :order_size, :integer, default: 1
  
    timestamps()
  end

  @doc false
  def changeset(production_line_recipe, attrs) do
    production_line_recipe
    |> cast(attrs, [:production_line_id, :recipe_id, :order_size])
    |> validate_required([:production_line_id, :recipe_id, :order_size])
  end
end
