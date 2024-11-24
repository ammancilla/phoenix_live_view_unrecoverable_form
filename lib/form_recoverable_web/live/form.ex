defmodule FormRecoverableWeb.FormLive do
  @moduledoc false

  use FormRecoverableWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :form, to_form(%{"name" => nil}))}
  end

  @impl true
  def handle_event("validate", params, socket) do
    {:noreply, assign(socket, :form, to_form(params))}
  end

  def handle_event("submit", _params, _socket), do: raise("crash live view")

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto flex justify-between prose">
      <div>
        <h2>The Form</h2>
        <.simple_form id="person-form" for={@form} phx-change="validate" phx-submit="submit">
          <.input field={@form[:name]} label="name" />
          <:actions>
            <.button phx-disable-with="Saving...">Crash LiveView</.button>
          </:actions>
        </.simple_form>
      </div>

      <div>
        <h2>The Form from a Live Component</h2>
        <.live_component
          id="form-live-component"
          form={@form}
          module={FormRecoverableWeb.FormLiveComponent}
        />
      </div>
    </div>
    """
  end
end

defmodule FormRecoverableWeb.FormLiveComponent do
  @moduledoc false

  use FormRecoverableWeb, :live_component

  @impl true
  def update(_assigns, socket) do
    {:ok, assign(socket, :form, to_form(%{"username" => nil}))}
  end

  @impl true
  def handle_event("validate", params, socket) do
    {:noreply, assign(socket, :form, to_form(params))}
  end

  def handle_event("submit", _params, _socket), do: raise("crash live component")

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        id={"#{System.unique_integer()}"}
        for={@form}
        phx-submit="submit"
        phx-target={@myself}
        phx-change="validate"
      >
        <.input id="name-live-component" field={@form[:name]} label="name" />
        <:actions>
          <.button phx-disable-with="Saving...">Crash LiveComponent</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
