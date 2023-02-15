defmodule Nabp.Materials do
  @moduledoc """
  The Materials context.
  """

  import Ecto.Query, warn: false
  alias Nabp.Repo

  alias Nabp.Materials.Material

  @doc """
  Returns the list of materials.

  ## Examples

      iex> list_materials()
      [%Material{}, ...]

  """
  def list_materials do
    Repo.all(Material)
  end

  @doc """
  Gets a single material.

  Raises `Ecto.NoResultsError` if the Material does not exist.

  ## Examples

      iex> get_material!(123)
      %Material{}

      iex> get_material!(456)
      ** (Ecto.NoResultsError)

  """
  def get_material!(id), do: Repo.get!(Material, id)

  @doc """
  Gets a single material by matching its ticker.

  Raises `Ecto.NoResultsError` if the Material does not exist.

  ## Examples

      iex> get_material_by_ticker!(ticker)
      %Material{}

      iex> get_material_by_ticker!(bad_ticker)
      ** (Ecto.NoResultsError)
  """
  def get_material_by_ticker!(ticker), do: Repo.get_by!(Material, ticker: ticker)

  @doc """
  Gets the category_name of a material, given its ticker.

  Raises `Ecto.NoResultsError` if the Material does not exist.

  ## Examples

      iex> get_category_name_by_material_ticker!("C")
      "elements"

      iex> get_category_name_by_material_ticker!("fake ticker")
      ** (Ecto.NoResultsError)
  """
  def get_category_name_by_material_ticker!(ticker) do
    material = get_material_by_ticker!(ticker)
    material.category_name
  end

  @doc """
  Creates a material.

  ## Examples

      iex> create_material(%{field: value})
      {:ok, %Material{}}

      iex> create_material(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_material(attrs \\ %{}) do
    %Material{}
    |> Material.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a material.

  ## Examples

      iex> update_material(material, %{field: new_value})
      {:ok, %Material{}}

      iex> update_material(material, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_material(%Material{} = material, attrs) do
    material
    |> Material.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a material.

  ## Examples

      iex> delete_material(material)
      {:ok, %Material{}}

      iex> delete_material(material)
      {:error, %Ecto.Changeset{}}

  """
  def delete_material(%Material{} = material) do
    Repo.delete(material)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking material changes.

  ## Examples

      iex> change_material(material)
      %Ecto.Changeset{data: %Material{}}

  """
  def change_material(%Material{} = material, attrs \\ %{}) do
    Material.changeset(material, attrs)
  end
end
