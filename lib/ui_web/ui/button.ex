# DONE
defmodule UI.Button do
  @moduledoc false

  alias UI.Button.Variant
  alias UI.Icons

  use UiWeb, :html

  attr :level, :atom, default: :info, values: [:white, :info, :success, :warning, :danger]
  attr :size, :atom, default: :md, values: [:xs, :sm, :md, :lg, :xl]

  attr :loading?, :boolean, default: false

  attr :extra_class, :string, default: nil

  attr :base_variant, :any, default: &Variant.default_base/4

  attr :left_icon_variant, :any, default: &Variant.default_base_left_icon/2
  attr :left_loading_variant, :any, default: &Variant.default_base_left_loading/1

  attr :loading_variant, :any, default: &Variant.default_base_loading/1

  attr :right_icon_variant, :any, default: &Variant.default_base_right_icon/2
  attr :right_loading_variant, :any, default: &Variant.default_base_right_loading/1

  attr :rest, :global

  slot :left_icon do
    attr :has_loading_state?, :boolean
  end

  slot :right_icon do
    attr :has_loading_state?, :boolean
  end

  slot :inner_block

  # TODO Make the loading icon a slot (look in link module)
  def base(assigns) do
    assert_single_slot!(assigns.left_icon)
    assert_single_slot!(assigns.right_icon)

    ~H"""
    <button class={@base_variant.(@level, @size, @loading?, @extra_class)} {@rest}>
      <%= if slot_assigned?(@left_icon) do %>
        <div class="grid">
          <span ui-left-icon class="col-start-1 row-start-1">
            <%= render_slot(
              @left_icon,
              @left_icon_variant.(@size, get_slot_attr(@left_icon, :has_loading_state?, true))
            ) %>
          </span>

          <Icons.loading
            :if={get_slot_attr(@left_icon, :has_loading_state?, true)}
            ui-loading
            class={@left_loading_variant.(@size)}
          />
        </div>
      <% end %>

      <div>
        <Icons.loading
          :if={not slot_assigned?(@left_icon) and not slot_assigned?(@right_icon)}
          ui-loading
          class={@loading_variant.(@size)}
        />
      </div>
      
      <%= render_slot(@inner_block) %>

      <%= if slot_assigned?(@right_icon) do %>
        <div class="grid">
          <span ui-right-icon class="col-start-1 row-start-1">
            <%= render_slot(
              @right_icon,
              @right_icon_variant.(@size, get_slot_attr(@right_icon, :has_loading_state?, true))
            ) %>
          </span>

          <Icons.loading
            :if={get_slot_attr(@right_icon, :has_loading_state?, true)}
            ui-loading
            class={@right_loading_variant.(@size)}
          />
        </div>
      <% end %>
    </button>
    """
  end

  attr :level, :atom, default: :info, values: [:white, :info, :success, :warning, :danger]
  attr :size, :atom, default: :md, values: [:xs, :sm, :md, :lg, :xl]

  attr :rounded?, :boolean, default: false
  attr :loading?, :boolean, default: false

  attr :base_variant, :any, default: &Variant.default_icon/4

  attr :icon_variant, :any, default: &Variant.default_icon_icon/2
  attr :loading_variant, :any, default: &Variant.default_icon_loading/1

  attr :rest, :global

  slot :icon, required: true do
    attr :has_loading_state?, :boolean
  end

  def icon(assigns) do
    assert_single_slot!(assigns.icon)

    ~H"""
    <button class={@base_variant.(@level, @size, @rounded?, @loading?)} {@rest}>
      <div class="grid">
        <%= render_slot(@icon, @icon_variant.(@size, get_slot_attr(@icon, :has_loading_state?, true))) %>

        <Icons.loading
          :if={get_slot_attr(@icon, :has_loading_state?, true)}
          ui-loading
          class={@loading_variant.(@size)}
        />
      </div>
    </button>
    """
  end
end
