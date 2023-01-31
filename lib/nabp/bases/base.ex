defmodule Nabp.Bases.Base do
  alias Nabp.Bases.ProductionLine
  use Ecto.Schema
  import Ecto.Changeset

  schema "bases" do
    field :available_area, :integer
    field :cogc, :string
    field :experts, :map
    field :permits, :integer
    field :used_area, :integer
    belongs_to :user, Nabp.Accounts.User
    embeds_many :production_lines, Nabp.Bases.ProductionLine, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(base, attrs) do
    base
    |> cast(attrs, [:experts, :permits, :available_area, :used_area, :cogc])
    |> cast_embed(:production_lines)
    |> validate_required([:experts, :permits, :available_area])
  end

  def production_line_changeset(base, attrs) do
    base
    |> cast(attrs, [])
    |> cast_embed(:production_lines, required: true)
  end
end
