defmodule Nabp.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nabp.Recipes.IOMaterial
  alias Nabp.ProductionLineRecipe

  @derive {Jason.Encoder, except: [:__meta__, :building]}

  schema "recipes" do
    field :name, :string
    field :time_ms, :integer
    belongs_to :building, Nabp.Buildings.Building
    embeds_many :inputs, IOMaterial
    embeds_many :outputs, IOMaterial
    many_to_many :production_lines, Nabp.Bases.ProductionLine, join_through: ProductionLineRecipe

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :time_ms, :building_id])
    |> cast_embed(:inputs)
    |> cast_embed(:outputs)
    |> validate_required([:name, :time_ms])
  end
end
