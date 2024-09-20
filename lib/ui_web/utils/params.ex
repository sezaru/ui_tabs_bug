defmodule UiWeb.Utils.Params do
  @moduledoc false

  use TypedStruct

  typedstruct enforce: true do
    field :possible_fields, [String.t()]
    field :params, map, default: %{}
  end

  @spec new(list(atom), map) :: t
  def new(possible_fields, params \\ %{}) do
    params = params |> filter_fields(possible_fields) |> convert_params()

    struct!(__MODULE__, possible_fields: possible_fields, params: params)
  end

  @spec merge(t, atom, any) :: t
  def merge(params, key, value), do: merge(params, %{to_string(key) => value})

  @spec merge(t, map) :: t
  def merge(params, new_params) do
    new_params =
      new_params
      |> filter_fields(params)
      |> convert_params()
      |> then(&Map.merge(params.params, &1))

    %{params | params: new_params}
  end

  @spec update(t, :atom, (any -> any)) :: t
  def update(params, key, update_fun) do
    updated_value = params.params |> Map.get(key) |> update_fun.()

    merge(params, key, updated_value)
  end

  @spec replace(t, atom, any) :: t
  def replace(params, key, value), do: replace(params, %{to_string(key) => value})

  @spec replace(t, map) :: t
  def replace(params, new_params) do
    new_params = new_params |> filter_fields(params) |> convert_params()

    %{params | params: new_params}
  end

  @spec remove(t, atom | list(atom)) :: t
  def remove(params, field) when is_atom(field), do: remove(params, [field])

  def remove(params, fields) when is_list(fields),
    do: %{params | params: Map.drop(params.params, fields)}

  @spec clean(t) :: t
  def clean(params), do: %{params | params: %{}}

  @spec params(t) :: map
  def params(%{params: params}), do: params

  @spec take(t, list(atom)) :: map
  def take(%{params: params}, fields), do: Map.take(params, fields)

  @spec get(t, atom, any) :: any
  def get(%{params: params}, key, default \\ nil), do: Map.get(params, key, default)

  defp filter_fields(params, _) when map_size(params) == 0, do: %{}

  defp filter_fields(params, %{possible_fields: possible_fields}),
    do: filter_fields(params, possible_fields)

  defp filter_fields(params, possible_fields) do
    possible_fields = convert_possible_fields(possible_fields)
    params = Map.new(params, fn {key, value} -> {to_string(key), value} end)

    Map.take(params, possible_fields)
  end

  defp convert_params(params) when is_map(params),
    do: Map.new(params, fn {key, value} -> {String.to_atom(key), value} end)

  defp convert_possible_fields(possible_fields), do: Enum.map(possible_fields, &to_string/1)
end
