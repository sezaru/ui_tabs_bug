defmodule UiWeb.Utils.JSExtra do
  @moduledoc false

  alias Phoenix.LiveView.JS

  @spec set_text_content(JS.t(), String.t(), Keyword.t()) :: JS.t()
  def set_text_content(js \\ %JS{}, text, opts) do
    target = Keyword.fetch!(opts, :to)

    JS.dispatch(js, "phx:set-text-content", to: target, detail: text)
  end

  @spec set_input_value(JS.t(), String.t() | nil, Keyword.t()) :: JS.t()
  def set_input_value(js \\ %JS{}, text, opts) do
    target = Keyword.fetch!(opts, :to)

    JS.dispatch(js, "ui:set-input-value", to: target, detail: %{text: text})
  end

  @spec copy_input_value_to_clipboard(JS.t(), Keyword.t()) :: JS.t()
  def copy_input_value_to_clipboard(js \\ %JS{}, opts) do
    target = Keyword.fetch!(opts, :from)

    JS.dispatch(js, "ui:copy-input-value-to-clipboard", to: target)
  end

  @spec log(JS.t(), String.t() | map) :: JS.t()
  def log(js \\ %JS{}, message), do: JS.dispatch(js, "phx:console-log", detail: message)
end
