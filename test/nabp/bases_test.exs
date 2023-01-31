defmodule Nabp.BasesTest do
  use Nabp.DataCase

  alias Nabp.Bases

  describe "bases" do
    alias Nabp.Bases.Base

    import Nabp.BasesFixtures

    @invalid_attrs %{available_area: nil, cogc: nil, experts: nil, permits: nil, used_area: nil}

    test "list_bases/0 returns all bases" do
      base = base_fixture()
      assert Bases.list_bases() == [base]
    end

    test "get_base!/1 returns the base with given id" do
      base = base_fixture()
      assert Bases.get_base!(base.id) == base
    end

    test "create_base/1 with valid data creates a base" do
      valid_attrs = %{available_area: 42, cogc: "some cogc", experts: %{}, permits: 42, used_area: 42}

      assert {:ok, %Base{} = base} = Bases.create_base(valid_attrs)
      assert base.available_area == 42
      assert base.cogc == "some cogc"
      assert base.experts == %{}
      assert base.permits == 42
      assert base.used_area == 42
    end

    test "create_base/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bases.create_base(@invalid_attrs)
    end

    test "update_base/2 with valid data updates the base" do
      base = base_fixture()
      update_attrs = %{available_area: 43, cogc: "some updated cogc", experts: %{}, permits: 43, used_area: 43}

      assert {:ok, %Base{} = base} = Bases.update_base(base, update_attrs)
      assert base.available_area == 43
      assert base.cogc == "some updated cogc"
      assert base.experts == %{}
      assert base.permits == 43
      assert base.used_area == 43
    end

    test "update_base/2 with invalid data returns error changeset" do
      base = base_fixture()
      assert {:error, %Ecto.Changeset{}} = Bases.update_base(base, @invalid_attrs)
      assert base == Bases.get_base!(base.id)
    end

    test "delete_base/1 deletes the base" do
      base = base_fixture()
      assert {:ok, %Base{}} = Bases.delete_base(base)
      assert_raise Ecto.NoResultsError, fn -> Bases.get_base!(base.id) end
    end

    test "change_base/1 returns a base changeset" do
      base = base_fixture()
      assert %Ecto.Changeset{} = Bases.change_base(base)
    end

    # TODO: write up the create_production_line/2 test
  end

  describe "Base calculations" do
    alias Nabp.Bases.Base

    import Nabp.BasesFixtures

    test "5 BMPs consume 17.86 C/day" do
      {:ok, base} = bmps_base_fixture()

      inputs = Bases.calculate_inputs(base)
      carbon_input = Enum.find(inputs, fn x -> x.ticker == "C" end)

      carbon_amount =
        carbon_input.amount
        |> Decimal.from_float()
        |> Decimal.round(2)
      assert Decimal.compare(carbon_amount, Decimal.from_float(17.86)) == :eq
    end
  end
end
