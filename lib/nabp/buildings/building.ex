defmodule Nabp.Buildings.Building do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :recipes]}

  schema "buildings" do
    field :ticker, :string
    field :area_cost, :integer, default: 0
    field :engineers, :integer, default: 0
    field :expertise, Ecto.Enum, values: [:agriculture, :chemistry, :construction, :electronics,
                                          :food_industries, :fuel_refining, :manufacturing,
                                          :metallurgy, :resource_extraction]
    field :name, :string
    field :pioneers, :integer, default: 0
    field :scientists, :integer, default: 0
    field :settlers, :integer, default: 0
    field :technicians, :integer, default: 0
    has_many :recipes, Nabp.Recipes.Recipe

    timestamps()
  end

  @doc false
  def changeset(building, attrs) do
    building
    |> cast(attrs, [:ticker, :name, :expertise, :pioneers, :settlers, :technicians, :engineers, :scientists, :area_cost])
    |> validate_required([:ticker, :name, :pioneers, :settlers, :technicians, :engineers, :scientists, :area_cost])
  end
end
