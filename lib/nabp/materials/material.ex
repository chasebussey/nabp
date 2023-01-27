defmodule Nabp.Materials.Material do
  use Ecto.Schema
  import Ecto.Changeset

  schema "materials" do
    field :category_name, :string
    field :name, :string
    field :ticker, :string
    field :volume, :float
    field :weight, :float

    timestamps()
  end

  @doc false
  def changeset(material, attrs) do
    material
    |> cast(attrs, [:name, :ticker, :category_name, :weight, :volume])
    |> validate_required([:name, :ticker, :category_name, :weight, :volume])
  end
end
