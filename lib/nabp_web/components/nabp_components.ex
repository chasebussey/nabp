defmodule NabpWeb.NabpComponents do
  @moduledoc """
  Provides custom UI components.
  """
  use Phoenix.Component

  alias Nabp.Materials
  alias Nabp.Bases
  alias Phoenix.LiveView.JS
  import NabpWeb.Gettext
  import NabpWeb.CoreComponents

  # this is a lot.
  @category_colors %{"agricultural products" => "#671d1d", "alloys" => "#855628",
                     "chemicals" => "#c03764", "construction materials" => "#2164dc",
                     "construction parts" => "#325674", "construction prefabs" => "#18276b",
                     "consumables (basic)" => "#9f3838", "consumables (luxury)" => "#90202f",
                     "drones" => "#943c1a", "electronic devices" => "#5e1c9b", "electronic parts" => "#6235be",
                     "electronic pieces" => "#805bc6", "electronic systems" => "#3b2254",
                     "elements" => "#48392b", "energy systems" => "#1d462f", "fuels" => "#278427",
                     "gases" => "#0b7476", "liquids" => "#7aacd2", "medical equipment" => "#5db25d",
                     "metals" => "#3e3e3e", "minerals" => "#a27a52", "ores" => "#5a5f69",
                     "plastics" => "#832946", "ship engines" => "#a13108", "ship kits" => "#a05b07",
                     "ship parts" => "#a16b08", "ship shields" => "#eb8e0b", "software components" => "#928339",
                     "software systems" => "#433c0c", "software tools" => "#8b6c1d", "textiles" => "#5b632a",
                     "unit prefabs" => "#272526", "utility" => "#ac9f93"}
  
  def production_line_display(assigns) do
    ~H"""
    <div class="mt-2">
      <h2 class="text-md leading-8 text zinc-500">Production Lines</h2>
    </div>
    <div class="flex max-w-3xl ring-1 rounded-lg h-96">
      <div :for={production_line <- @production_lines} class="my-2 mx-2">
        <div class="flex px-2 py-2 ring-1 rounded-lg w-32 justify-center h-full">
          <.building_icon ticker={production_line.building_ticker}/>
        </div>
      </div>
    </div>
    """
  end

  attr :ticker, :string
  def building_icon(assigns) do
    ~H"""
      <svg width="32" height="32">
        <rect width="32" height="32" style="fill:rgb(72,160,180)"/>
        <text x="50%" y="50%" class="font-semibold text-xs" dominant-baseline="middle" text-anchor="middle" fill="#b3ffff"><%= @ticker %></text>
      </svg>
    """
  end

  attr :ticker, :string
  attr :amount, :string
  attr :industry, :string 
  def material_icon(assigns) do
    color = Map.get(@category_colors, assigns.industry)
    assigns = assign(assigns, :color, color)
    ~H"""
      <svg width="32" height="32">
        <defs>
          <filter x="0" y="0" id="solid">
            <feFlood flood-color="#23282b"/>
            <feComposite in="SourceGraphic" operator="over"/>
          </filter>
        </defs>
        <rect width="32" height="32" fill={"#{@color}"}/>
        <text x="50%" y="50%" class="font-semibold text-xs" dominant-baseline="middle" text-anchor="middle" fill="white" fill-opacity="60%"><%= @ticker %></text>
        <text filter="url(#solid)" x="100%" y="100%" text-anchor="end" style="font-size:0.45rem; font-weight:thin; overflow: hidden; width: 32px" fill="#ffffff"><%= @amount %></text>
        <text x="100%" y="100%" text-anchor="end" style="font-size:0.45rem; font-weight: thin; overflow: hidden; width: 32px" fill="#ffffff"><%= @amount %></text>
      </svg>
    """
  end

  @doc """
  Renders a nearly identical table to CoreComponents.table/1, but without actions
  to avoid some of the issues with rendering IOMaterials.
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true

  slot :col, required: true do
    attr :label, :string
  end
  def simple_table(assigns) do
    ~H"""
    <div id={@id} class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="mt-5 w-[40rem] sm:w-full">
        <thead class="text-left text-[0.8125rem] leading-6 text-zinc-500 dark:text-gray-400">
          <tr>
            <th :for={col <- @col} class="p-0 pb-4 pr-6 font-normal"><%= col[:label] %></th>
          </tr>
        </thead>
        <tbody class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700 dark:divide-gray-800 dark:border-gray-700 dark:text-gray-200">
          <tr
            :for={row <- @rows}
            class="relative group hover:bg-zinc-50 dark:hover:bg-gray-800"
          >
            <td :for={{col, i} <- Enum.with_index(@col)} class="p-0">
              <div class="block py-4 pl-2 pr-6">
                <span class={["relative", i == 0 && "font-semibold text-zinc-900 dark:text-white"]}>
                  <%= render_slot(col, row) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  attr :base, :map
  def production_summary(assigns) do
    inputs = Bases.calculate_inputs(assigns.base)
    outputs = Bases.calculate_outputs(assigns.base)

    ~H"""
      <h2>Production Summary</h2>
      <div class="rounded-lg ring-1 ring-blue-600 mt-2 px-2 py-2">
        <h3>Inputs</h3>
        <.simple_table id="inputs" rows={inputs}>
          <:col :let={input} label="">
            <.material_icon ticker={input.ticker} amount={Decimal.round(input.amount, 1)}
              industry={Materials.get_category_name_by_material_ticker!(input.ticker)}/>
          </:col>
          <:col :let={input} label="Amount">
            <%= Decimal.round(input.amount, 2) %>
          </:col>
        </.simple_table>

        <hr class="my-4"/>

        <h3>Outputs</h3>
        <.simple_table id="outputs" rows={outputs}>
          <:col :let={output} label="">
            <.material_icon ticker={output.ticker} amount={Decimal.round(output.amount, 1)}
              industry={Materials.get_category_name_by_material_ticker!(output.ticker)}/>
          </:col>
          <:col :let={output} label="Amount">
            <%= Decimal.round(output.amount, 2) %>
          </:col>
        </.simple_table>

      </div>
    """
  end
end
