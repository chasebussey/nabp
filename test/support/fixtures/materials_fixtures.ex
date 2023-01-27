defmodule Nabp.MaterialsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nabp.Materials` context.
  """

  @doc """
  Generate a material.
  """
  def material_fixture(attrs \\ %{}) do
    {:ok, material} =
      attrs
      |> Enum.into(%{
        category_name: "some category_name",
        name: "some name",
        ticker: "some ticker",
        volume: 120.5,
        weight: 120.5
      })
      |> Nabp.Materials.create_material()

    material
  end
end
