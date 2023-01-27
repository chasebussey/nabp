defmodule Nabp.MaterialsTest do
  use Nabp.DataCase

  alias Nabp.Materials

  describe "materials" do
    alias Nabp.Materials.Material

    import Nabp.MaterialsFixtures

    @invalid_attrs %{category_name: nil, name: nil, ticker: nil, volume: nil, weight: nil}

    test "list_materials/0 returns all materials" do
      material = material_fixture()
      assert Materials.list_materials() == [material]
    end

    test "get_material!/1 returns the material with given id" do
      material = material_fixture()
      assert Materials.get_material!(material.id) == material
    end

    test "create_material/1 with valid data creates a material" do
      valid_attrs = %{category_name: "some category_name", name: "some name", ticker: "some ticker", volume: 120.5, weight: 120.5}

      assert {:ok, %Material{} = material} = Materials.create_material(valid_attrs)
      assert material.category_name == "some category_name"
      assert material.name == "some name"
      assert material.ticker == "some ticker"
      assert material.volume == 120.5
      assert material.weight == 120.5
    end

    test "create_material/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Materials.create_material(@invalid_attrs)
    end

    test "update_material/2 with valid data updates the material" do
      material = material_fixture()
      update_attrs = %{category_name: "some updated category_name", name: "some updated name", ticker: "some updated ticker", volume: 456.7, weight: 456.7}

      assert {:ok, %Material{} = material} = Materials.update_material(material, update_attrs)
      assert material.category_name == "some updated category_name"
      assert material.name == "some updated name"
      assert material.ticker == "some updated ticker"
      assert material.volume == 456.7
      assert material.weight == 456.7
    end

    test "update_material/2 with invalid data returns error changeset" do
      material = material_fixture()
      assert {:error, %Ecto.Changeset{}} = Materials.update_material(material, @invalid_attrs)
      assert material == Materials.get_material!(material.id)
    end

    test "delete_material/1 deletes the material" do
      material = material_fixture()
      assert {:ok, %Material{}} = Materials.delete_material(material)
      assert_raise Ecto.NoResultsError, fn -> Materials.get_material!(material.id) end
    end

    test "change_material/1 returns a material changeset" do
      material = material_fixture()
      assert %Ecto.Changeset{} = Materials.change_material(material)
    end
  end
end
