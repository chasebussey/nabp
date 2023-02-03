defmodule NabpWeb.NabpComponents do
  @moduledoc """
  Provides custom UI components.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import NabpWeb.Gettext
  import NabpWeb.CoreComponents
  
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
end
