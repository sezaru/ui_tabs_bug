defmodule Ui.Resources.TableManagement.Actions.GetByName.Preparations.CreateIfNil do
  @moduledoc false

  alias Ui.Resources.TableManagement

  use Ash.Resource.Preparation

  @impl true
  def init(opts), do: {:ok, opts}

  @impl true
  def prepare(query, _opts, _context), do: Ash.Query.after_action(query, &do_prepare/2)

  defp do_prepare(query, []) do
    read = fn query ->
      name = Ash.Query.get_argument(query, :name)
      default_columns = Ash.Query.get_argument(query, :default_columns)
      default_rows_per_page = Ash.Query.get_argument(query, :default_rows_per_page)

      args = %{
        name: name,
        enabled_columns: default_columns,
        columns_order: default_columns,
        rows_per_page: default_rows_per_page
      }

      TableManagement
      |> Ash.Changeset.for_create(:create, args)
      |> Ash.create()
      |> Ash.load(:columns)
    end

    with {:ok, result} <- read.(query), do: {:ok, [result]}
  end

  defp do_prepare(_query, results), do: {:ok, results}
end
