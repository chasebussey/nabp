defmodule Nabp.Bases do
  @moduledoc """
  The Bases context.
  """

  import Ecto.Query, warn: false
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

  def create_production_line(%Base{} = base, attrs \\ %{}) do
    line = 
      %ProductionLine{}
      |> ProductionLine.changeset(attrs)

    update_base(base, %{production_lines: line})
  end
end
