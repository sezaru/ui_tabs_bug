defmodule PrettierFormatter do
  @moduledoc """
  A formatter that can be plugged in to `mix format` in order to format javascrit
  and css files.

  ## Usage

  Add `PrettierFormatter` to the `.formatter.exs` plugin list.

  ```
  [
    plugins: [PrettierFormatter],
    inputs: [
      ...
      "assets/js/**/*.{js,ts,jsx,tsx}",
      "assets/tailwind.config.js",
      "assets/css/**/*.css"
    ]
  ]
  ```
  """

  @behaviour Mix.Tasks.Format

  @prettier_bin "./assets/node_modules/.bin/prettier"

  def features(_opts) do
    [extensions: ~w(.js .ts .jsx .tsx .css)]
  end

  def format(contents, opts) do
    extension = Keyword.fetch!(opts, :extension)

    do_format(contents, extension)
  end

  defp do_format(contents, extension) when extension in ~w(.js .ts .jsx .tsx),
    do: run_format(contents, "typescript")

  defp do_format(contents, extension) when extension in ~w(.css), do: run_format(contents, "css")

  defp run_format(contents, parser) do
    contents = String.replace(contents, "'", "'\"'\"'")

    {contents, 0} =
      System.cmd("sh", ["-c", "echo '#{contents}' | #{@prettier_bin} --parser #{parser}"])

    contents
  end
end
