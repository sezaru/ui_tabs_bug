defmodule UI.Icons do
  @moduledoc false

  use Phoenix.Component

  import Turboprop.Merge, only: [merge: 1]

  attr :class, :any, default: ""

  attr :rest, :global

  def person(assigns) do
    ~H"""
    <svg
      class={@class}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      fill="currentColor"
      viewBox="0 0 20 20"
      {@rest}
    >
      <path d="M10 0a10 10 0 1 0 10 10A10.011 10.011 0 0 0 10 0Zm0 5a3 3 0 1 1 0 6 3 3 0 0 1 0-6Zm0 13a8.949 8.949 0 0 1-4.951-1.488A3.987 3.987 0 0 1 9 13h2a3.987 3.987 0 0 1 3.951 3.512A8.949 8.949 0 0 1 10 18Z" />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def loading(assigns) do
    ~H"""
    <svg
      class={merge(["animate-spin", @class])}
      aria-hidden="true"
      role="status"
      viewBox="0 0 100 101"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      {@rest}
    >
      <path
        d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
        fill="#E5E7EB"
      />
      <path
        d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
        fill="currentColor"
      />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def down_arrow(assigns) do
    ~H"""
    <svg
      class={@class}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 10 6"
      {@rest}
    >
      <path
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="m1 1 4 4 4-4"
      />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def upload(assigns) do
    ~H"""
    <svg
      class={@class}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 20 16"
      {@rest}
    >
      <path
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"
      />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def eye(assigns) do
    ~H"""
    <svg
      class={@class}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      fill="none"
      viewBox="0 0 24 24"
      {@rest}
    >
      <path
        stroke="currentColor"
        stroke-width="2"
        d="M21 12c0 1.2-4.03 6-9 6s-9-4.8-9-6c0-1.2 4.03-6 9-6s9 4.8 9 6Z"
      />
      <path stroke="currentColor" stroke-width="2" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def eye_slash(assigns) do
    ~H"""
    <svg
      class={@class}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      fill="none"
      viewBox="0 0 24 24"
      {@rest}
    >
      <path
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M3.933 13.909A4.357 4.357 0 0 1 3 12c0-1 4-6 9-6m7.6 3.8A5.068 5.068 0 0 1 21 12c0 1-3 6-9 6-.314 0-.62-.014-.918-.04M5 19 19 5m-4 7a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"
      />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def close_circle(assigns) do
    ~H"""
    <svg
      class={@class}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      fill="none"
      viewBox="0 0 24 24"
      {@rest}
    >
      <path
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="m15 9-6 6m0-6 6 6m6-3a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
      />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def clipboard(assigns) do
    ~H"""
    <svg
      class={@class}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      fill="none"
      viewBox="0 0 24 24"
      {@rest}
    >
      <path
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M15 4h3a1 1 0 0 1 1 1v15a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1h3m0 3h6m-6 5h6m-6 4h6M10 3v4h4V3h-4Z"
      />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def undefined_sort(assigns) do
    ~H"""
    <svg
      class={@class}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      fill="currentColor"
      viewBox="0 0 24 24"
      {@rest}
    >
      <path d="M8.574 11.024h6.852a2.075 2.075 0 0 0 1.847-1.086 1.9 1.9 0 0 0-.11-1.986L13.736 2.9a2.122 2.122 0 0 0-3.472 0L6.837 7.952a1.9 1.9 0 0 0-.11 1.986 2.074 2.074 0 0 0 1.847 1.086Zm6.852 1.952H8.574a2.072 2.072 0 0 0-1.847 1.087 1.9 1.9 0 0 0 .11 1.985l3.426 5.05a2.123 2.123 0 0 0 3.472 0l3.427-5.05a1.9 1.9 0 0 0 .11-1.985 2.074 2.074 0 0 0-1.846-1.087Z" />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def desc_sort(assigns) do
    ~H"""
    <svg
      class={@class}
      viewBox="0 0 24 24"
      fill="currentColor"
      xmlns="http://www.w3.org/2000/svg"
      {@rest}
    >
      <path d="M 15.426 12.976 L 8.574 12.976 C 7.804 12.967 7.093 13.386 6.727 14.063 C 6.387 14.693 6.429 15.46 6.837 16.048 L 10.263 21.098 C 11.109 22.299 12.889 22.299 13.735 21.098 L 17.162 16.048 C 17.57 15.46 17.612 14.693 17.272 14.063 C 16.906 13.386 16.195 12.968 15.426 12.976 L 15.426 12.976 Z" />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def asc_sort(assigns) do
    ~H"""
    <svg
      class={@class}
      viewBox="0 0 24 24"
      fill="currentColor"
      xmlns="http://www.w3.org/2000/svg"
      {@rest}
    >
      <path d="M 8.574 11.024 L 15.426 11.024 C 16.195 11.032 16.906 10.614 17.273 9.938 C 17.613 9.308 17.571 8.54 17.163 7.952 L 13.736 2.9 C 12.891 1.698 11.109 1.698 10.264 2.9 L 6.837 7.952 C 6.429 8.54 6.387 9.308 6.727 9.938 C 7.094 10.615 7.805 11.033 8.574 11.024 L 8.574 11.024 Z" />
    </svg>
    """
  end

  attr :class, :any, default: ""

  attr :rest, :global

  def drag(assigns) do
    ~H"""
    <svg
      class={@class}
      xmlns="http://www.w3.org/2000/svg"
      width="1em"
      height="1em"
      viewBox="0 0 24 24"
      {@rest}
    >
      <g fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="8" cy="4" r="1" transform="rotate(90 8 4)" /><circle
          cx="16"
          cy="4"
          r="1"
          transform="rotate(90 16 4)"
        /><circle cx="8" cy="12" r="1" transform="rotate(90 8 12)" /><circle
          cx="16"
          cy="12"
          r="1"
          transform="rotate(90 16 12)"
        /><circle cx="8" cy="20" r="1" transform="rotate(90 8 20)" /><circle
          cx="16"
          cy="20"
          r="1"
          transform="rotate(90 16 20)"
        />
      </g>
    </svg>
    """
  end
end
