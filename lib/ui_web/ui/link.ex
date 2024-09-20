defmodule UI.Link do
  @moduledoc false

  alias UI.Link.Variant

  use UiWeb, :html

  attr :extra_class, :string, default: nil

  attr :base_variant, :any, default: &Variant.default_base/1

  attr :rest, :global

  slot :inner_block

  def base(assigns) do
    ~H"""
    <a class={@base_variant.(@extra_class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </a>
    """
  end

  attr :size, :atom, default: :md, values: [:xs, :sm, :md, :lg, :xl]

  attr :loading?, :boolean, default: false

  attr :extra_class, :string, default: nil

  attr :base_variant, :any, default: &Variant.default_icon/2

  attr :icon_variant, :any, default: &Variant.default_icon_icon/2
  attr :loading_variant, :any, default: &Variant.default_icon_loading/1

  attr :rest, :global

  slot :inner_block

  slot :icon, required: true

  slot :loading

  def icon(assigns) do
    assert_single_slot!(assigns.icon)

    ~H"""
    <a class={@base_variant.(@loading?, @extra_class)} {@rest}>
      <div class="grid">
        <%= render_slot(@icon, @icon_variant.(@size, slot_assigned?(@loading))) %>

        <%= if slot_assigned?(@loading) do %>
          <%= render_slot(@loading, @loading_variant.(@size)) %>
        <% end %>
      </div>
    </a>
    """
  end
end
