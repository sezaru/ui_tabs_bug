defmodule UiWeb.DynamicTabsLive.Params do
  @moduledoc false

  alias UiWeb.DynamicTabsLive.DOM

  alias UiWeb.Utils.Params

  use UiWeb, :live_component

  @accepted_params [:dynamic_tabs]

  def parse_params(params), do: Params.new(@accepted_params, params)

  def dynamic_tabs(params), do: Params.get(params, :dynamic_tabs, [])

  def params(params), do: Params.params(params)

  def handle_params(socket, params) do
    %{live_action: live_action} = socket.assigns

    current_tab_id = params |> Map.get("current_tab_id")

    params = parse_params(params)

    socket
    |> assign(params: params)
    |> do_handle_params(live_action, current_tab_id)
  end

  def add_tab(socket, new_id) do
    %{params: params} = socket.assigns

    update_tabs = fn
      nil, new_value -> [new_value]
      values, new_value -> values |> Kernel.++([new_value]) |> Enum.uniq()
    end

    params = Params.update(params, :dynamic_tabs, &update_tabs.(&1, new_id))

    dbg(params.params)

    dbg("Will push patch to: #{DOM.url(:dynamic, new_id, params)}")

    socket
    |> assign(params: params)
    |> assign(current_tab_id: new_id)
    |> push_patch(to: DOM.url(:dynamic, new_id, params))
  end

  def remove_tab(socket, id) do
    %{params: params, live_action: live_action, current_tab_id: current_tab_id} = socket.assigns

    update_tabs = fn
      nil, _ -> []
      values, old_value -> values -- [old_value]
    end

    params = Params.update(params, :dynamic_tabs, &update_tabs.(&1, id))

    maybe_reset_current_tab = fn socket, id ->
      if live_action == :dynamic and current_tab_id == id do
        socket
        |> push_exec("phx-click", to: "#profile_tab")
        |> push_patch(to: DOM.url(:index, nil, params))
      else
        push_patch(socket, to: DOM.url(live_action, current_tab_id, params))
      end
    end

    socket
    |> assign(params: params)
    |> maybe_reset_current_tab.(id)
  end

  defp maybe_insert_current_tab_id(tabs, nil), do: tabs
  defp maybe_insert_current_tab_id(tabs, current_tab_id), do: List.insert_at(tabs, -1, current_tab_id)

  defp do_handle_params(socket, :dynamic, id), do: assign(socket, current_tab_id: id)
  defp do_handle_params(socket, _, _), do: socket
end
