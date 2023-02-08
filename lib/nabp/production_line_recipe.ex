defmodule Nabp.ProductionLineRecipe do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "production_lines_recipes" do

    belongs_to :production_line, Nabp.Bases.ProductionLine
    belongs_to :recipe, Nabp.Recipes.Recipe
  
    timestamps()
  end

  @doc false
  def changeset(production_line_recipe, attrs) do
    production_line_recipe
    |> cast(attrs, [])
    |> validate_required([])
  end
end
