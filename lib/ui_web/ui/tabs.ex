defmodule UI.Tabs do
  @moduledoc false

  alias Phoenix.LiveView.JS

  use Phoenix.Component

  import Turboprop.Variants, only: [variant: 2]

  attr :rest, :global

  slot :inner_block, required: true

  def tabs(assigns) do
    ~H"""
    <div class={variant(tabs(), slot: :outer_tabs)}>
      <ul tabs class={variant(tabs(), slot: :tabs)} role="tablist" {@rest}>
        <%= render_slot(@inner_block) %>
      </ul>
    </div>
    """
  end

  attr :id, :string, required: true

  attr :content_id, :string, required: true

  attr :mount_selected?, :boolean, default: false

  attr :on_selected, JS, default: %JS{}
  attr :on_unselected, JS, default: %JS{}

  attr :rest, :global

  slot :inner_block, required: true

  def tab(assigns) do
    ~H"""
    <button
      id={@id}
      tab
      class={variant(tab(), selected?: @mount_selected?)}
      phx-click={select(@id, @content_id)}
      type="button"
      role="tab"
      aria-controls={@content_id}
      aria-selected={"#{@mount_selected?}"}
      data-on-selected={@on_selected}
      data-on-unselected={@on_unselected}
      phx-mounted={if @mount_selected?, do: select(@id, @content_id)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  attr :rest, :global

  slot :inner_block, required: true

  def contents(assigns) do
    ~H"""
    <div tabs_contents {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true

  attr :tab_id, :string, required: true

  attr :mount_selected?, :boolean, default: false

  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <div
      tab_content
      class={variant(content(), selected?: @mount_selected?)}
      id={@id}
      role="tabpanel"
      aria-labelledby={@tab_id}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @ease_in {"ease-out duration-150", "opacity-0", "opacity-100"}

  defp select(%JS{} = js \\ %JS{}, id, content_id) do
    selected_classes = variant(tab(), selected?: true)
    unselected_classes = variant(tab(), selected?: false)

    selected_tab_path = "ul[tabs]:has(> button##{id}[tab]) > button[tab][aria-selected=true]"

    selected_content_path =
      "div[tabs_contents]:has(> div##{content_id}[tab_content]) > div[tab_content]:not(.hidden)"

    js
    |> JS.exec("data-on-unselected", to: selected_tab_path)
    |> JS.remove_class(selected_classes, to: selected_tab_path)
    |> JS.add_class(unselected_classes, to: selected_tab_path)
    |> JS.set_attribute({"aria-selected", "false"}, to: selected_tab_path)
    |> JS.exec("data-on-selected")
    |> JS.remove_class(unselected_classes)
    |> JS.add_class(selected_classes)
    |> JS.set_attribute({"aria-selected", "true"})
    |> JS.add_class("hidden", to: selected_content_path)
    |> JS.remove_class("hidden", to: "##{content_id}")
    |> JS.transition(@ease_in, to: "##{content_id}")
  end

  # defp on_mount(%JS{} = js \\ %JS{}), do: JS.exec(js, "data-on-selected")

  defp content do
    [
      base: "p-4 rounded-lg bg-gray-50 dark:bg-gray-800",
      variants: [
        selected?: [
          false: "hidden"
        ]
      ]
    ]
  end

  defp tab do
    [
      base: "inline-block p-4 border-b-2 rounded-t-lg",
      variants: [
        selected?: [
          true: """
          text-blue-600 hover:text-blue-600 dark:text-blue-500 dark:hover:text-blue-500
          border-blue-600 dark:border-blue-500
          """,
          false: """
          text-gray-500 hover:text-gray-600 dark:text-gray-400 dark:hover:text-gray-300
          border-gray-100 dark:border-gray-700 dark:border-transparent
          hover:border-gray-300
          """
        ]
      ]
    ]
  end

  defp tabs do
    [
      outer_tabs: "mb-4 border-b border-gray-200 dark:border-gray-700",
      tabs: "flex flex-wrap -mb-px text-sm font-medium text-center gap-2"
    ]
  end
end
