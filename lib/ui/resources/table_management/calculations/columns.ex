defmodule Ui.Resources.TableManagement.Calculations.Columns do
  @moduledoc false

  alias Ui.Resources.TableManagement.Column

  use Ash.Resource.Calculation

  @impl true
  def init(opts), do: {:ok, opts}

  @impl true
  def calculate(resources, _opts, _context) do
    Enum.map(resources, fn resource ->
      %{enabled_columns: enabled_columns, columns_order: columns_order} = resource

      Enum.map(columns_order, fn column ->
        enabled? =
          case Enum.find(enabled_columns, fn rhs -> column == rhs end) do
            nil -> false
            _ -> true
          end

        Column
        |> Ash.Changeset.for_create(:create, %{name: column, enabled?: enabled?})
        |> Ash.create!()
      end)
    end)
  end
end
