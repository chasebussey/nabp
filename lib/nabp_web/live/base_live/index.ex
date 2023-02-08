defmodule NabpWeb.BaseLive.Index do
  use NabpWeb, :live_view

  alias Nabp.Bases
  alias Nabp.Bases.Base

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :bases, list_bases())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Base")
    |> assign(:base, Bases.get_base!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Base")
    |> assign(:base, %Base{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bases")
    |> assign(:base, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    base = Bases.get_base!(id)
    {:ok, _} = Bases.delete_base(base)

    {:noreply, assign(socket, :bases, list_bases())}
  end

  defp list_bases do
    Bases.list_bases()
  end
end
