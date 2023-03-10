defmodule Nabp.Recipes.IOMaterial do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  embedded_schema do
    field :amount, :decimal
    field :ticker, :string
  end

  @doc false
  def changeset(io_material, attrs) do
    io_material
    |> cast(attrs, [:ticker, :amount])
    |> validate_required([:ticker, :amount])
  end
end
