defmodule Ui do
  @moduledoc """
  Ui keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def add_resources(number) do
    alias Ui.Resources.Resource1

    Enum.each(1..div(number, 2), fn index ->
      Ash.create!(Resource1, %{name: "#{index}", type: "onwer"})
    end)

    Enum.each(div(number, 2)..number, fn index ->
      Ash.create!(Resource1, %{name: "#{index}", type: "blibs"})
    end)

    # Ash.create!(TableEnabledColumns, %{
    #   name: "table",
    #   enabled_columns: %TableEnabledColumns.MainTable{name: true, type: true}
    # })
  end
end
