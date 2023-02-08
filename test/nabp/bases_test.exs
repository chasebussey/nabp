defmodule Nabp.BasesTest do
  use Nabp.DataCase

  alias Nabp.Bases.ProductionLine
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
      valid_attrs = %{name: "test", available_area: 42, cogc: "some cogc", experts: %{}, permits: 42, used_area: 42}

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
  end

  describe "Production lines" do
    alias Nabp.Bases.Base

    import Nabp.BasesFixtures

    @valid_attrs %{num_buildings: 2, building_ticker: "SE", recipes: [], efficiency: 1.00, expertise: :electronics}
    @invalid_attrs %{num_buildings: 2, building_ticker: nil, recipes: [], efficiency: 1.00, expertise: nil}
    
    test "create_production_line/2 with valid data creates a production line" do
      assert {:ok, %ProductionLine{} = production_line} = Bases.create_production_line(@valid_attrs)

      assert production_line.num_buildings == 2
      assert production_line.building_ticker == "SE"
      assert production_line.recipes == []
      assert Decimal.eq?(production_line.efficiency, Decimal.from_float(1.00))
    end

    test "create_production_line/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bases.create_production_line(@invalid_attrs)
    end

    test "update_production_line/2 with valid data updates the production line" do
      line = production_line_fixture()
      update_attrs = %{num_buildings: 4, building_ticker: "SE"}
      
      assert {:ok, %ProductionLine{} = line} = Bases.update_production_line(line, update_attrs)
      assert line.num_buildings == 4
    end

    test "update_production_line/2 with invalid data returns error changeset" do
      line = production_line_fixture()
      assert {:error, %Ecto.Changeset{}} = Bases.update_production_line(line, @invalid_attrs)
    end

  end

  describe "Base calculations" do
    alias Nabp.Bases.Base

    import Nabp.BasesFixtures

    test "5 BMPs consume 17.86 C/day" do
      base = bmps_base_fixture()
      base = Repo.preload(base, :production_lines)

      inputs = Bases.calculate_inputs(base)
      carbon_input = Enum.find(inputs, fn x -> x.ticker == "C" end)

      carbon_amount =
        carbon_input.amount
        |> Decimal.round(2)
      assert Decimal.compare(carbon_amount, Decimal.from_float(17.86)) == :eq
    end

    test "5 BMPs produce 3,571.4 PE/day" do
      base = 
        bmps_base_fixture()
        |> Repo.preload(:production_lines)

      outputs = Bases.calculate_outputs(base)
      pe_output = Enum.find(outputs, fn x -> x.ticker == "PE" end)

      pe_amount =
        pe_output.amount
        |> Decimal.round(1)

      target_amount = Decimal.from_float(3_571.4)

      assert Decimal.compare(pe_amount, target_amount) == :eq
    end

    @tag current: true
    test "parse_experts/1 returns the appropriate efficiency factors" do
      base = experts_base_fixture()
      assert base.experts.electronics == 5
    end

    test "apply_experts_bonus/1 returns a %Base{}" do
      base = 
        base_fixture()
        |> Repo.preload(:production_lines)

      assert %Base{} = Bases.apply_experts_bonus(base)
    end

    test "apply_experts_bonus/1 on 5 BMP base with 3 experts updates efficiency to 1.1248" do
      base = 
        bmps_experts_fixture()
        |> Repo.preload(:production_lines)

      [bmp_line | _] = Bases.apply_experts_bonus(base)
      assert Decimal.eq?(bmp_line.efficiency, Decimal.from_float(1.1248))
    end

    test "calculate_expert_bonus/2 returns 0.284 for a line with 5 experts" do
      line = production_line_fixture()
      experts = %{electronics: 5}

      assert Bases.calculate_expert_bonus(line, experts) == Decimal.from_float(0.284)
    end
  end
end
