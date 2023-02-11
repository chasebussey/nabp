defmodule Nabp.FIOAdapter do
  alias Nabp.Recipes.IOMaterial
  @doc """
  This module presents functions to retrieve data from the FIO rest API at
  https://rest.fnar.net
  """

  @fio_url Application.compile_env(:nabp, :fio_url)

  def get_all_buildings() do
    case HTTPoison.get("#{@fio_url}/building/allbuildings") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> decode_with_atom_keys()
        |> Enum.map(fn x -> underscore_expertise(x) end)
        |> Enum.map(fn x -> Map.delete(x, :recipes) end)
        |> Enum.map(fn x -> Nabp.Buildings.create_building(x) end)

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {status_code, body}

      {:error, _} ->
        {:error, "FIO unreachable"}
    end
  end

  defp underscore_expertise(map) do
    if Map.get(map, :expertise) == nil do
      map
    else
      expertise = 
        map
        |> Map.get(:expertise)
        |> Macro.underscore()

      Map.put(map, :expertise, expertise)
    end
  end

  def get_all_recipes() do
    case HTTPoison.get("#{@fio_url}/recipes/allrecipes") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> decode_with_atom_keys()
        |> Enum.map(fn x -> put_name(x) end)
        |> Enum.map(fn x -> convert_outputs(x) end)
        |> Enum.map(fn x -> convert_inputs(x) end)
        |> Enum.map(fn x -> put_building_id(x) end)
        |> Enum.map(fn x -> Nabp.Recipes.create_recipe(x) end)

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {status_code, body}

      {:error, _} ->
        {:error, "FIO unreachable"}
    end
  end

  def get_all_materials() do
    case HTTPoison.get("#{@fio_url}/material/allmaterials") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> 
        body
        |> decode_with_atom_keys()
        |> Enum.map(fn x -> Nabp.Materials.create_material(x) end)

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {status_code, body}

      {:error, _} ->
        {:error, "FIO unreachable"}
    end
  end

  defp into_struct(map, struct) do
    struct(struct, map)
  end
  
  defp decode_with_atom_keys(map) do
    Jason.decode!(map, [keys: fn x -> x |> Macro.underscore() |> String.to_atom() end])
  end

  defp put_name(%{recipe_name: name} = recipe) do
    Map.put_new(recipe, :name, name)
  end

  defp put_building_id(%{building_ticker: building_ticker} = recipe) do
    building = Nabp.Buildings.get_building_by_ticker!(building_ticker)
    Map.put_new(recipe, :building_id, building.id)
  end

  defp convert_inputs(%{inputs: inputs} = recipe) when inputs != [] do
    new_inputs =
      recipe.inputs
      |> Enum.map(fn x -> into_struct(x, IOMaterial) end)

    Map.put(recipe, :inputs, new_inputs)
    recipe
  end

  defp convert_inputs(%{inputs: inputs} = recipe) when inputs == [], do: recipe 

  defp convert_outputs(%{outputs: outputs} = recipe) when outputs != [] do
    new_outputs =
      recipe.outputs
      |> Enum.map(fn x -> into_struct(x, IOMaterial) end)

    Map.put(recipe, :outputs, new_outputs)
    recipe
  end

  defp convert_outputs(%{outputs: outputs} = recipe) when outputs == [], do: recipe
end
