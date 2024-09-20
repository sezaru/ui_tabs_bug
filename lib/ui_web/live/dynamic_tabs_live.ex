defmodule UiWeb.DynamicTabsLive do
  @moduledoc false

  alias UiWeb.DynamicTabsLive.{Params, DOM}

  alias UI.Tabs

  alias Phoenix.LiveView.JS

  use UiWeb, :live_view

  def mount(_params, _session, socket) do

    socket
    |> assign(current_tab_id: nil)
    |> ok()
  end

  def handle_params(params, _uri, %{assigns: %{params: _}} = socket) do
    IO.puts("IGNORING HANDLE PARAMS")

    dbg(params)
    dbg(socket.assigns.params)
    dbg(socket.assigns.current_tab_id)

    socket |> no_reply()
  end

  def handle_params(params, uri, socket) do
    IO.puts("FIRST HANDLE PARAMS")

    socket
    |> Params.handle_params(params)
    |> no_reply()
  end

  def handle_event("add_tab", %{"id" => id}, socket) do
    %{params: params} = socket.assigns

    dbg("Add tab #{id}")

    socket
    |> Params.add_tab(id)
    |> no_reply()
  end

  def handle_event("remove_tab", %{"id" => id}, socket) do
    socket
    |> Params.remove_tab(id)
    |> no_reply()
  end

  def render(assigns) do
    ~H"""
    <.tabs live_action={@live_action} current_tab_id={@current_tab_id} params={@params} />
    <.tabs_contents live_action={@live_action} current_tab_id={@current_tab_id} params={@params} />
    """
  end

  defp tabs(assigns) do
    ~H"""
    <Tabs.tabs>
      <Tabs.tab
        id="profile_tab"
        content_id="profile_content"
        mount_selected?={@live_action == :index}
        on_selected={JS.patch(DOM.url(:index, nil, @params))}
      >
        Profile
      </Tabs.tab>

      <Tabs.tab
        :for={tab_id <- @params |> Params.params() |> Map.get(:dynamic_tabs, [])}
        id={DOM.dynamic_tab_id(tab_id)}
        content_id={DOM.dynamic_content_id(tab_id)}
        mount_selected?={@live_action == :dynamic and @current_tab_id == tab_id}
        on_selected={make_dynamic_tab(tab_id).on_selected.(@params)}
        on_unselected={make_dynamic_tab(tab_id).on_unselected.()}
      >
        <%= make_dynamic_tab(tab_id).name %>

        <UI.Link.icon
          phx-click={JS.hide(to: "##{DOM.dynamic_tab_id(tab_id)}") |> JS.push("remove_tab")}
          phx-value-id={tab_id}
        >
          <:icon :let={class}>
            <UI.Icons.close_circle class={class} />
          </:icon>

          <:loading :let={class}>
            <UI.Icons.loading class={class} />
          </:loading>
        </UI.Link.icon>
      </Tabs.tab>
    </Tabs.tabs>
    """
  end

  defp tabs_contents(assigns) do
    ~H"""
    <Tabs.contents>
      <Tabs.content id="profile_content" tab_id="profile_tab" mount_selected?={@live_action == :index}>
        <div class="flex gap-2">
        <UI.Button.base phx-click={JS.exec("phx-click", to: "##{1 |> DOM.dynamic_tab_id()}") |> JS.push("add_tab", value: %{id: "1"})}>add tab 1</UI.Button.base>
        <UI.Button.base phx-click={JS.exec("phx-click", to: "##{2 |> DOM.dynamic_tab_id()}") |> JS.push("add_tab", value: %{id: "2"})}>add tab 2</UI.Button.base>
        <UI.Button.base phx-click={JS.exec("phx-click", to: "##{3 |> DOM.dynamic_tab_id()}") |> JS.push("add_tab", value: %{id: "3"})}>add tab 3</UI.Button.base>
        <UI.Button.base phx-click={JS.exec("phx-click", to: "##{4 |> DOM.dynamic_tab_id()}") |> JS.push("add_tab", value: %{id: "4"})}>add tab 4</UI.Button.base>
        <UI.Button.base phx-click={JS.exec("phx-click", to: "##{5 |> DOM.dynamic_tab_id()}") |> JS.push("add_tab", value: %{id: "5"})}>add tab 5</UI.Button.base>
        <UI.Button.base phx-click={JS.exec("phx-click", to: "##{6 |> DOM.dynamic_tab_id()}") |> JS.push("add_tab", value: %{id: "6"})}>add tab 6</UI.Button.base>
        </div>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          This is some placeholder content the <strong class="font-medium text-gray-800 dark:text-white">Profile tab's associated content</strong>. Clicking another tab will toggle the visibility of this one for the next. The tab JavaScript swaps classes to control the content visibility and styling.
        </p>
      </Tabs.content>

      <Tabs.content
        :for={tab_id <- @params |> Params.params() |> Map.get(:dynamic_tabs, [])}
        id={DOM.dynamic_content_id(tab_id)}
        tab_id={DOM.dynamic_tab_id(tab_id)}
        mount_selected?={@live_action == :dynamic and @current_tab_id == tab_id}
      >
        <pre><%= inspect(tab_id, pretty: true) %></pre>
      </Tabs.content>
    </Tabs.contents>
    """
  end

  defp make_dynamic_tab(id) do
    %{
      id: id,
      name: "Dyn tab #{id}",
      on_selected: fn params -> :dynamic |> DOM.url(id, params) |> JS.patch() end,
      on_unselected: fn -> %JS{} end
    }
  end
end
