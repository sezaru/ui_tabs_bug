defmodule UI.Link.Variant do
  @moduledoc false

  import Turboprop.Variants, only: [variant: 2]

  @transition_effect "transition ease-in-out duration-300"

  def default_base(extra_class), do: variant(link(), class: extra_class)

  def default_icon(loading?, extra_class) do
    variant(icon_link(), loading?: loading?, class: extra_class)
  end

  def default_icon_icon(size, has_loading?) do
    variant(icon_link(), slot: :icon, size: size, has_loading?: has_loading?)
  end

  def default_icon_loading(size) do
    variant(icon_link(), slot: :loading, size: size)
  end

  def link do
    [
      slots: [
        base: "font-medium text-blue-600 dark:text-blue-500 hover:underline cursor-pointer"
      ]
    ]
  end

  def icon_link do
    [
      slots: [
        base: """
        inline-flex items-center
        text-blue-600 dark:text-blue-500
        cursor-pointer group/link
        """,
        icon: """
        col-start-1 row-start-1
        opacity-100 group-ui-loading/link:opacity-0
        #{@transition_effect}
        """,
        loading: """
        col-start-1 row-start-1
        opacity-0 group-ui-loading/link:opacity-100
        #{@transition_effect}
        """
      ],
      variants: [
        loading?: [
          true: "ui-loading"
        ]
      ],
      compound_slots: [
        [slots: [:icon, :loading], size: :xs, class: "size-3"],
        [slots: [:icon, :loading], size: :sm, class: "size-3"],
        [slots: [:icon, :loading], size: :md, class: "size-3.5"],
        [slots: [:icon, :loading], size: :lg, class: "size-4"],
        [slots: [:icon, :loading], size: :xl, class: "size-4"],
        [
          slots: [:icon],
          has_loading?: true,
          class: """
          group-ui-loading/link:opacity-0
          #{@transition_effect}
          """
        ]
      ],
      default_variants: [
        loading?: false,
        has_loading?: false
      ]
    ]
  end
end
