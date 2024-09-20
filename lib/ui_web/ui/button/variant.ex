defmodule UI.Button.Variant do
  @moduledoc false

  import Turboprop.Variants, only: [variant: 2]

  @transition_effect "transition ease-in-out duration-300"

  def default_base(level, size, loading?, extra_class) do
    variant(button(), level: level, size: size, loading?: loading?, class: extra_class)
  end

  def default_base_left_icon(size, has_loading?) do
    variant(button(), slot: :left_icon, size: size, has_loading?: has_loading?)
  end

  def default_base_left_loading(size) do
    variant(button(), slot: :left_loading, size: size)
  end

  def default_base_loading(size) do
    variant(button(), slot: :loading, size: size)
  end

  def default_base_right_icon(size, has_loading?) do
    variant(button(), slot: :right_icon, size: size, has_loading?: has_loading?)
  end

  def default_base_right_loading(size) do
    variant(button(), slot: :right_loading, size: size)
  end

  def default_icon(level, size, rounded?, loading?) do
    variant(icon_button(), level: level, size: size, rounded?: rounded?, loading?: loading?)
  end

  def default_icon_icon(size, has_loading?) do
    variant(icon_button(), slot: :icon, size: size, has_loading?: has_loading?)
  end

  def default_icon_loading(size) do
    variant(icon_button(), slot: :loading, size: size)
  end

  def button do
    [
      slots: [
        base: """
        focus:ring-2 font-medium rounded-lg focus:outline-none text-center
        items-center flex group/button
        """,
        left_icon: """
        me-2
        opacity-100 group-ui-loading/button:opacity-0
        #{@transition_effect}
        """,
        right_icon: """
        ms-2
        opacity-100 group-ui-loading/button:opacity-0
        #{@transition_effect}
        """,
        left_loading: """
        me-2
        col-start-1 row-start-1
        opacity-0 group-ui-loading/button:opacity-100
        #{@transition_effect}
        """,
        loading: "me-2 hidden group-ui-loading/button:block",
        right_loading: """
        ms-2
        col-start-1 row-start-1
        opacity-0 group-ui-loading/button:opacity-100
        #{@transition_effect}
        """
      ],
      variants: [
        level: button_levels(),
        loading?: [
          true: "ui-loading"
        ]
      ],
      compound_slots: [
        [slots: [:base], size: :xs, class: "px-3 py-2 text-xs"],
        [slots: [:base], size: :sm, class: "px-3 py-2 text-sm"],
        [slots: [:base], size: :md, class: "px-5 py-2.5 text-sm"],
        [slots: [:base], size: :lg, class: "px-5 py-3 text-base"],
        [slots: [:base], size: :xl, class: "px-6 py-3.5 text-base"],
        [
          slots: [:left_icon, :right_icon, :left_loading, :loading, :right_loading],
          size: :xs,
          class: "size-3"
        ],
        [
          slots: [:left_icon, :right_icon, :left_loading, :loading, :right_loading],
          size: :sm,
          class: "size-3"
        ],
        [
          slots: [:left_icon, :right_icon, :left_loading, :loading, :right_loading],
          size: :md,
          class: "size-3.5"
        ],
        [
          slots: [:left_icon, :right_icon, :left_loading, :loading, :right_loading],
          size: :lg,
          class: "size-4"
        ],
        [
          slots: [:left_icon, :right_icon, :left_loading, :loading, :right_loading],
          size: :xl,
          class: "size-4"
        ],
        [
          slots: [:left_icon, :right_icon],
          has_loading?: true,
          class: """
          group-ui-loading/button:opacity-0
          #{@transition_effect}
          """
        ]
      ],
      default_variants: [
        level: :info,
        size: :md,
        loading?: false,
        has_loading?: false
      ]
    ]
  end

  def icon_button do
    [
      slots: [
        base: """
        focus:ring-2 font-medium focus:outline-none text-center
        items-center inline-flex group/button
        """,
        icon: """
        col-start-1 row-start-1
        opacity-100 group-ui-loading/button:opacity-0
        #{@transition_effect}
        """,
        loading: """
        col-start-1 row-start-1
        opacity-0 group-ui-loading/button:opacity-100
        #{@transition_effect}
        """
      ],
      variants: [
        level: button_levels(),
        rounded?: [
          true: "rounded-full",
          false: "rounded-lg"
        ],
        loading?: [
          true: "ui-loading"
        ]
      ],
      compound_slots: [
        [slots: [:base], size: :xs, class: "p-2.5"],
        [slots: [:base], size: :sm, class: "p-3"],
        [slots: [:base], size: :md, class: "p-3"],
        [slots: [:base], size: :lg, class: "p-4"],
        [slots: [:base], size: :xl, class: "p-[1.125rem]"],
        [slots: [:icon, :loading], size: :xs, class: "size-3"],
        [slots: [:icon, :loading], size: :sm, class: "size-3"],
        [slots: [:icon, :loading], size: :md, class: "size-3.5"],
        [slots: [:icon, :loading], size: :lg, class: "size-4"],
        [slots: [:icon, :loading], size: :xl, class: "size-4"],
        [
          slots: [:icon],
          has_loading?: true,
          class: """
          group-ui-loading/button:opacity-0
          #{@transition_effect}
          """
        ]
      ],
      default_variants: [
        level: :info,
        size: :md,
        loading?: false,
        has_loading?: false
      ]
    ]
  end

  defp button_levels do
    [
      # primary: "",
      # secondary: "",
      white: """
      text-gray-900 dark:text-gray-400 hover:text-gray-700 dark:hover:text-white disabled:text-gray-900/50 disabled:dark:text-gray-900/50
      bg-white dark:bg-gray-80 hover:bg-gray-100 ark:hover:bg-gray-700
      focus:ring-gray-200 dark:focus:ring-gray-700
      border border-gray-200 dark:border-gray-600
      """,
      info:
        "text-white bg-blue-700 hover:bg-blue-800 focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800",
      success:
        "text-white bg-green-700 hover:bg-green-800 focus:ring-green-300 dark:bg-green-600 dark:hover:bg-green-700 dark:focus:ring-green-800",
      warning:
        "text-white bg-yellow-400 hover:bg-yellow-500 focus:ring-yellow-300 dark:focus:ring-yellow-900",
      danger:
        "text-white bg-red-700 hover:bg-red-800 focus:ring-red-300 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900"
    ]
  end
end
