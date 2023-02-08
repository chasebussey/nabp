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
        name: "test base",
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
  def bmps_base_fixture() do
    base = base_fixture()

    {:ok, line} = 
      %{}
      |> Enum.into(%{
          num_buildings: 5,
          building_ticker: "BMP",
          recipes: [
            %{
                name: "1xC 2xH=>200xPE",
                time_ms: 24192000,
                inputs: [
                  %{
                    ticker: "C",
                    amount: 1
                  },
                  %{
                    ticker: "H",
                    amount: 2
                  }
                ],
                outputs: [
                  %{
                    ticker: "PE",
                    amount: 200
                  }
                ]
              }
          ],
          efficiency: 1.00,
          expertise: :manufacturing,
          base_id: base.id
        })
      |> Nabp.Bases.create_production_line()
  
    base
  end

  @doc """
  Generates a base with a 5 BMP production line with 3 manufacturing experts.
  """
  def bmps_experts_fixture() do
    base = bmps_base_fixture()
    attrs =
      %{}
      |> Enum.into(%{experts: %{manufacturing: 3}})
    {:ok, base} =
      Nabp.Bases.update_base(base, attrs)

    base
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
          name: "experts test",
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
