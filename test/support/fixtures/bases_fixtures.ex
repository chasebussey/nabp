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

  @doc """
  Generates a base with a 5 BMP production line producing PE at 1.00 efficiency.
  """
  # TODO: Make this work more correctly
  def bmps_base_fixture(attrs \\ %{}) do
    base = base_fixture()
    base = Map.put(base, :experts, %{manufacturing: 3})

    base_with_line = 
      %{}
      |> Enum.into(%{
        production_lines: [%{
          num_buildings: 5,
          building_ticker: "BMP",
          recipes: [
            %Nabp.Recipes.Recipe{
              name: "1xC 2xH=>200xPE",
              time_ms: 24192000,
              inputs: [
                %Nabp.Recipes.IOMaterial{
                  amount: 2,
                  ticker: "H"
                },
                %Nabp.Recipes.IOMaterial{
                  amount: 1,
                  ticker: "C"
                }
              ],
              outputs: [
                %Nabp.Recipes.IOMaterial{
                  amount: 200,
                  ticker: "PE"
                }
              ]
            }
          ],
          expertise: :manufacturing
        }
      ]
    })
      
    Nabp.Bases.update_base(base, base_with_line)
  end

  @doc """
  Generates a 2 SE production line for testing
  """
  def production_line_fixture() do
    {:ok, line} = 
      %{}
      |> Enum.into(%{
          num_buildings: 2,
          building_ticker: "SE",
          recipes: [],
          efficiency: 1.00,
          expertise: :electronics
      })
      |> Nabp.Bases.create_production_line()

    line
  end

  @doc """
  Generates a base with 5 electronics experts for testing
  """
  def experts_base_fixture(attrs \\ %{}) do
    {:ok, base} =
      attrs
      |> Enum.into(%{
          experts: %{
            electronics: 5
          },
          available_area: 500,
          permits: 1
      })
      |> Nabp.Bases.create_base()

    base
  end
end
