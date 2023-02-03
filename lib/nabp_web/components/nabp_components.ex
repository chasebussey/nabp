defmodule NabpWeb.NabpComponents do
  @moduledoc """
  Provides custom UI components.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import NabpWeb.Gettext
  import NabpWeb.CoreComponents

  # this is a lot.
  @category_colors %{"agricultural products" => "#4098ac", "alloys" => "#4098ac",
                     "chemicals" => "#4098ac", "construction materials" => "#4098ac",
                     "construction parts" => "#4098ac", "construction prefabs" => "#4098ac",
                     "consumables (basic)" => "#4098ac", "consumables (luxury)" => "#4098ac",
                     "drones" => "#4098ac", "electronic devices" => "#4098ac", "electronic parts" => "#4098ac",
                     "electronic pieces" => "#4098ac", "electronic systems" => "#4098ac",
                     "elements" => "#4098ac", "energy systems" => "#4098ac", "fuels" => "#4098ac",
                     "gases" => "#4098ac", "liquids" => "#4098ac", "medical equipment" => "#4098ac",
                     "metals" => "#4098ac", "minerals" => "#4098ac", "ores" => "#4098ac",
                     "plastics" => "#832946", "ship engines" => "#4098ac", "ship kits" => "#4098ac",
                     "ship parts" => "#4098ac", "ship shields" => "#4098ac", "software components" => "#4098ac",
                     "software systems" => "#4098ac", "software tools" => "#4098ac", "textiles" => "#4098ac",
                     "unit prefabs" => "#4098ac", "utility" => "#4098ac"}
  
  def production_line_display(assigns) do
    IO.inspect(assigns)
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
end
