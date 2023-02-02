defmodule Nabp.BuildingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nabp.Buildings` context.
  """

  @doc """
  Generate a building.
  """
  def building_fixture(attrs \\ %{}) do
    {:ok, building} =
      attrs
      |> Enum.into(%{
        ticker: "TST",
        area_cost: 42,
        engineers: 42,
        expertise: :manufacturing,
        name: "some name",
        pioneers: 42,
        scientists: 42,
        settlers: 42,
        technicians: 42
      })
      |> Nabp.Buildings.create_building()

    building
  end
end
