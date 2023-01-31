defmodule Nabp.Bases do
  @moduledoc """
  The Bases context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias Nabp.Recipes.IOMaterial
  alias Nabp.Bases.ProductionLine
  alias Nabp.Repo

  alias Nabp.Bases.Base

  @doc """
  Returns the list of bases.

  ## Examples

      iex> list_bases()
      [%Base{}, ...]

  """
  def list_bases do
    Repo.all(Base)
  end

  @doc """
  Gets a single base.

  Raises `Ecto.NoResultsError` if the Base does not exist.

  ## Examples

      iex> get_base!(123)
      %Base{}

      iex> get_base!(456)
      ** (Ecto.NoResultsError)

  """
  def get_base!(id), do: Repo.get!(Base, id)

  @doc """
  Creates a base.

  ## Examples

      iex> create_base(%{field: value})
      {:ok, %Base{}}

      iex> create_base(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_base(attrs \\ %{}) do
    %Base{}
    |> Base.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a base.

  ## Examples

      iex> update_base(base, %{field: new_value})
      {:ok, %Base{}}

      iex> update_base(base, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_base(%Base{} = base, attrs) do
    base
    |> Base.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a base.

  ## Examples

      iex> delete_base(base)
      {:ok, %Base{}}

      iex> delete_base(base)
      {:error, %Ecto.Changeset{}}

  """
  def delete_base(%Base{} = base) do
    Repo.delete(base)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking base changes.

  ## Examples

      iex> change_base(base)
      %Ecto.Changeset{data: %Base{}}

  """
  def change_base(%Base{} = base, attrs \\ %{}) do
    Base.changeset(base, attrs)
  end

  def create_production_line(attrs \\ %{}) do
    %ProductionLine{}
    |> ProductionLine.changeset(attrs)
    |> Changeset.apply_action(:create)
  end

  def update_production_line(%ProductionLine{} = line, attrs \\ %{}) do
    line
    |> ProductionLine.changeset(attrs)
    |> Changeset.apply_action(:update)
  end

  def add_production_line_to_base(%Base{} = base, %ProductionLine{} = line) do
    production_lines = 
      [line | base.production_lines]
      |> Enum.map(fn x -> Map.from_struct(x) end)
      |> Enum.reverse()

    attrs =
      %{}
      |> Enum.into(%{
          production_lines: production_lines
      })

    update_base(base, attrs)
  end

  def remove_production_line_from_base(%Base{} = base, %ProductionLine{} = line) do
    production_lines =
      base.production_lines
      |> List.delete(line)
      |> Enum.map(fn x -> Map.from_struct(x) end)
    attrs =
      %{}
      |> Enum.into(%{
          production_lines: Enum.map(production_lines, fn x -> Map.from_struct(x) end)
      })

    update_base(base, attrs)
  end

  @doc """
  For a given base, return a list of IOMaterials representing the total daily
  inputs across all production lines

  ## Examples

      iex> calculate_inputs(base)
      [%IOMaterial{}, ...]

  """
  def calculate_inputs(%Base{} = base) do
    base.production_lines
    |> Enum.flat_map(fn line -> calculate_materials_for_line(line, :inputs) end)
  end

  @doc """
  For a given base, return a list of IOMaterials representing the total daily
  outputs across all production lines

  ## Examples
      
      iex> calculate_outputs(base)
      [%IOMaterial{}, ...]

  """
  def calculate_outputs(%Base{} = base) do
    base.production_lines
    |> Enum.flat_map(fn line -> calculate_materials_for_line(line, :outputs) end)
  end

  defp calculate_materials_for_line(line, type) when is_atom(type) do
    line.recipes
    |> Enum.flat_map(fn x -> calculate_materials_for_recipe(x, line.efficiency, line.num_buildings, type) end)
  end

  defp calculate_materials_for_recipe(recipe, efficiency, num_buildings, type) when is_atom(type) do
    Map.get(recipe, type)
    |> scale_materials(recipe.time_ms, efficiency, num_buildings)
  end

  defp scale_materials(materials, time_ms, efficiency, num_buildings) do
    materials
    |> Enum.map(fn x -> %IOMaterial{
                          amount: x.amount * num_buildings * efficiency / time_ms * 86_400_000,
                          ticker: x.ticker
                        }
                end)
  end
end
