defmodule Nabp.BuildingsTest do
  use Nabp.DataCase

  alias Nabp.Buildings

  describe "buildings" do
    alias Nabp.Buildings.Building

    import Nabp.BuildingsFixtures

    @invalid_attrs %{area_cost: nil, engineers: nil, expertise: nil, name: nil, pioneers: nil, scientists: nil, settlers: nil, technicians: nil}

    test "list_buildings/0 returns all buildings" do
      building = building_fixture()
      assert Buildings.list_buildings() == [building]
    end

    test "get_building!/1 returns the building with given id" do
      building = building_fixture()
      assert Buildings.get_building!(building.id) == building
    end

    test "create_building/1 with valid data creates a building" do
      valid_attrs = %{ticker: "TST", area_cost: 42, engineers: 42, expertise: "some expertise", name: "some name", pioneers: 42, scientists: 42, settlers: 42, technicians: 42}

      assert {:ok, %Building{} = building} = Buildings.create_building(valid_attrs)
      assert building.area_cost == 42
      assert building.engineers == 42
      assert building.expertise == "some expertise"
      assert building.name == "some name"
      assert building.pioneers == 42
      assert building.scientists == 42
      assert building.settlers == 42
      assert building.technicians == 42
    end

    test "create_building/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Buildings.create_building(@invalid_attrs)
    end

    test "update_building/2 with valid data updates the building" do
      building = building_fixture()
      update_attrs = %{area_cost: 43, engineers: 43, expertise: "some updated expertise", name: "some updated name", pioneers: 43, scientists: 43, settlers: 43, technicians: 43}

      assert {:ok, %Building{} = building} = Buildings.update_building(building, update_attrs)
      assert building.area_cost == 43
      assert building.engineers == 43
      assert building.expertise == "some updated expertise"
      assert building.name == "some updated name"
      assert building.pioneers == 43
      assert building.scientists == 43
      assert building.settlers == 43
      assert building.technicians == 43
    end

    test "update_building/2 with invalid data returns error changeset" do
      building = building_fixture()
      assert {:error, %Ecto.Changeset{}} = Buildings.update_building(building, @invalid_attrs)
      assert building == Buildings.get_building!(building.id)
    end

    test "delete_building/1 deletes the building" do
      building = building_fixture()
      assert {:ok, %Building{}} = Buildings.delete_building(building)
      assert_raise Ecto.NoResultsError, fn -> Buildings.get_building!(building.id) end
    end

    test "change_building/1 returns a building changeset" do
      building = building_fixture()
      assert %Ecto.Changeset{} = Buildings.change_building(building)
    end
  end
end
