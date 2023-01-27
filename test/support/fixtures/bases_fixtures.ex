defmodule Nabp.BasesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nabp.Bases` context.
  """

  @doc """
  Generate a base.
  """
  def base_fixture(attrs \\ %{}) do
    {:ok, base} =
      attrs
      |> Enum.into(%{
        available_area: 42,
        cogc: "some cogc",
        experts: %{},
        permits: 42,
        used_area: 42
      })
      |> Nabp.Bases.create_base()

    base
  end
end
