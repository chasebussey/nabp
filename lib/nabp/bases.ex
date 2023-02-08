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

  @experts_factors %{5 => 0.284, 4 => 0.1974, 3 => 0.1248, 2 => 0.0696, 1 => 0.0306}

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

  @doc """
  Returns the list of production lines for the given base_id.

  ## Examples

      iex> list_production_lines(base_id)
      [%ProductionLine{}, ...]

  """
  def list_production_lines(base_id) when is_integer(base_id) do
    ProductionLine
    |> where([p], p.base_id == ^base_id)
    |> Repo.all()
  end

  @doc """
  Gets a single production line.

  Raises `Ecto.NoResultsError` if the production line does not exist.

  ## Examples

      iex> get_production_line!(123)
      %ProductionLine{}

      iex> get_production_line!(456)
      ** (Ecto.NoResultsError)
  """
  def get_production_line!(id), do: Repo.get!(ProductionLine, id)

  @doc """
  Creates a production line.

  ## Examples

      iex> create_production_line(%{field: value})
      {:ok, %ProductionLine{}}

      iex> create_production_line(%field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_production_line(attrs \\ %{}) do
    %ProductionLine{}
    |> ProductionLine.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a production line.

  ## Examples
      
      iex> update_production_line(%{field: value})
      {:ok, %ProductionLine{}}

      iex> update_production_line(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_production_line(%ProductionLine{} = line, attrs \\ %{}) do
    line
    |> ProductionLine.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a production line.

  ## Examples
      
      iex> delete_production_line(line)
      {:ok, %ProductionLine{}}

      iex> delete_production_line(line)
      {:error, %Ecto.Changeset{}}

  """
  def delete_production_line(%ProductionLine{} = line) do
    Repo.delete(line)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking production line changes.

  ## Examples

      iex> change_production_line(line)
      %Ecto.Changeset{data: %ProductionLine{}}
  """
  def change_production_line(%ProductionLine{} = line, attrs \\ %{}) do
    ProductionLine.changeset(line, attrs)
  end

  def parse_experts(%Base{experts: experts}) do
    experts
  end

  def apply_experts_bonus(%Base{experts: experts, production_lines: lines} = _base) when map_size(experts) > 0 do
    lines =
      lines
      |> Enum.map(fn line -> apply_bonus_to_line(line, calculate_expert_bonus(line, experts)) end)

    lines
  end

  def apply_experts_bonus(%Base{} = base), do: base 

  def apply_bonus_to_line(line, bonus) do
    attrs =
      %{}
      |> Enum.into(%{efficiency: Decimal.add(line.efficiency, bonus)})
    
    {:ok, new_line} = update_production_line(line, attrs)
    new_line
  end

  def calculate_expert_bonus(line, experts) do
    Decimal.from_float(@experts_factors[experts[line.expertise]])
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
    |> Enum.flat_map(fn line -> calculate_materials_for_line(line, "inputs") end)
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
    |> Enum.flat_map(fn line -> calculate_materials_for_line(line, "outputs") end)
  end

  defp calculate_materials_for_line(line, type) do
    line.recipes
    |> Enum.flat_map(fn x -> calculate_materials_for_recipe(x, line.efficiency, line.num_buildings, type) end)
  end

  defp calculate_materials_for_recipe(recipe, efficiency, num_buildings, type) do
    Map.get(recipe, type)
    |> scale_materials(recipe["time_ms"], efficiency, num_buildings)
  end

  defp scale_materials(materials, time_ms, efficiency, num_buildings) do
    materials
    |> Enum.map(fn x -> %IOMaterial{
                          amount: calculate_amount(x["amount"], num_buildings, efficiency, time_ms),
                          ticker: x["ticker"]
                        }
                end)
  end
  
  defp calculate_amount(base_amount, num_buildings, efficiency, time_ms) do
    base_amount = Decimal.new(base_amount)
    num_buildings = Decimal.new(num_buildings)
    time_ms = Decimal.new(time_ms)
    day_ms = Decimal.new(86_400_000)

    base_amount
    |> Decimal.mult(num_buildings)
    |> Decimal.mult(efficiency)
    |> Decimal.div(time_ms)
    |> Decimal.mult(day_ms)
  end
end
