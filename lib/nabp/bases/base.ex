defmodule Nabp.Bases.Base do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bases" do
    field :name, :string
    field :available_area, :integer
    field :cogc, :string
    field :experts, :map
    field :permits, :integer
    field :used_area, :integer
    belongs_to :user, Nabp.Accounts.User
    has_many :production_lines, Nabp.Bases.ProductionLine

    timestamps()
  end

  @doc false
  def changeset(base, attrs) do
    base
    |> cast(attrs, [:name, :experts, :permits, :available_area, :used_area, :cogc])
    |> validate_required([:name, :experts, :permits, :available_area])
  end

  def production_line_changeset(base, attrs) do
    base
    |> cast(attrs, [])
    |> cast_assoc(:production_lines)
  end
end
