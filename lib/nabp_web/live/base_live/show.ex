defmodule NabpWeb.BaseLive.Show do
  use NabpWeb, :live_view

  alias Nabp.Materials
  alias Nabp.Bases
  alias Nabp.Recipes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:base, Bases.get_full_base!(id))
     |> assign(:production_line_recipes, Bases.get_base_production_line_recipes(id))}
  end

  @impl true
  def handle_event("add_production_line", %{"production_line" => %{"ticker" => ticker}}, socket) do
    base_id = socket.assigns.base.id
    building = 
      ticker
      |> String.upcase()
      |> Nabp.Buildings.get_building_by_ticker!()

    attrs =
      %{}
      |> Enum.into(%{
          num_buildings: 1,
          building_ticker: String.upcase(ticker),
          building_id: building.id,
          expertise: building.expertise,
          base_id: base_id
        })

    {:ok, _line} = Bases.create_production_line(attrs)

    {:noreply, 
     socket
     |> assign(:base, Bases.get_full_base!(base_id))}
  end

  @impl true
  def handle_event("add_recipe", %{"recipe" => %{"line_id" => line_id, "id" => recipe_id}}, socket) do
    recipe = Recipes.get_recipe!(recipe_id)
    line = Bases.get_production_line!(line_id)

    {:ok, _line} = Bases.add_recipe_to_line(recipe, line)
    
    {:noreply,
     socket
     |> assign(:production_line_recipes, Bases.get_base_production_line_recipes(line.base_id))}
  end

  @impl true
  def handle_event("update_recipe_allocation",
                   %{"production_line_recipe" => %{"order_size" => _order_size, "line_id" => line_id, "recipe_id" => recipe_id}} = plr,
                   socket) do

    line = Bases.get_production_line!(line_id)
    line_recipe = Bases.get_production_line_recipe!(line_id, recipe_id)

    attrs = plr["production_line_recipe"]

    {:ok, _line_recipe} = Bases.update_production_line_recipe(line_recipe, attrs)

    {:noreply,
     socket
     |> assign(:base, Bases.get_full_base!(line.base_id))}
  end

  @impl true
  def handle_event("delete_production_line_recipe", %{"line_id" => line_id, "recipe_id" => recipe_id}, socket) do
    line = Bases.get_production_line!(line_id)
    line_recipe = Bases.get_production_line_recipe!(line_id, recipe_id)

    {:ok, _result} = Bases.delete_production_line_recipe(line_recipe)
    {:noreply,
     socket
     |> assign(:base, Bases.get_full_base!(line.base_id))}
  end

  defp get_industry_by_material_ticker(ticker) do
    material = Materials.get_material_by_ticker!(ticker)
    material.category_name
  end

  defp get_recipes_by_building_id(id) do
    recipe_names =
      Nabp.Recipes.get_recipes_by_building!(id)
      |> Enum.map(fn x -> {x.name, x.id} end)

    recipe_names
  end

  defp page_title(:show), do: "Show Base"
  defp page_title(:edit), do: "Edit Base"
end
