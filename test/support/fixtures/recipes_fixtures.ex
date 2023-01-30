defmodule Nabp.RecipesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nabp.Recipes` context.
  """

  @doc """
  Generate a recipe.
  """
  def recipe_fixture(attrs \\ %{}) do
    {:ok, recipe} =
      attrs
      |> Enum.into(%{
        inputs: %{},
        name: "some name",
        outputs: %{},
        time_ms: 42
      })
      |> Nabp.Recipes.create_recipe()

    recipe
  end
end
