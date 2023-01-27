defmodule Nabp.Recipes.IOMaterial do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :amount, :integer
    field :ticker, :string

    timestamps()
  end

  @doc false
  def changeset(io_material, attrs) do
    io_material
    |> cast(attrs, [:ticker, :amount])
    |> validate_required([:ticker, :amount])
  end
end
