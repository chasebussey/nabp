defmodule Nabp.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nabp.Recipes.IOMaterial

  schema "recipes" do
    field :name, :string
    field :duration_ms, :integer
    belongs_to :building, Nabp.Buildings.Building
    embeds_many :inputs, IOMaterial
    embeds_many :outputs, IOMaterial

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :duration_ms, :building_id])
    |> cast_embed(:inputs)
    |> cast_embed(:outputs)
    |> validate_required([:name])
  end
end
