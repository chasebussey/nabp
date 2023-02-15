defmodule NabpWeb.BaseLive.FormComponent do
  use NabpWeb, :live_component

  alias Nabp.Bases

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle></:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="base-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <.input field={{f, :name}} label="Base Name"/>

        <:actions>
          <.button phx-disable-with="Saving...">Save Base</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{base: base} = assigns, socket) do
    changeset = Bases.change_base(base)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"base" => base_params}, socket) do
    changeset =
      socket.assigns.base
      |> Bases.change_base(base_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"base" => base_params}, socket) do
    base_params = 
      base_params
      |> Map.put_new("experts", %{})
      |> Map.put_new("permits", 1)
      |> Map.put_new("available_area", 500)

    save_base(socket, socket.assigns.action, base_params)
  end

  defp save_base(socket, :edit, base_params) do
    case Bases.update_base(socket.assigns.base, base_params) do
      {:ok, _base} ->
        {:noreply,
         socket
         |> put_flash(:info, "Base updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_base(socket, :new, base_params) do
    case Bases.create_base(base_params) do
      {:ok, _base} ->
        {:noreply,
         socket
         |> put_flash(:info, "Base created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
