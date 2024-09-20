defmodule UiWeb.DynamicTabsLive.DOM do
  @moduledoc false

  alias UiWeb.Utils.Params

  use UiWeb, :verified_routes

  def dynamic_tab_id(id), do: "tabs_#{id}_tab"

  def dynamic_content_id(id), do: "tabs_#{id}_content"

  def url(:index, _, params), do: ~p"/dynamic_tabs?#{Params.params(params)}"
  def url(:load_shit, _, params), do: ~p"/dynamic_tabs/load_shit?#{Params.params(params)}"
  def url(:with_form, _, params), do: ~p"/dynamic_tabs/with_form?#{Params.params(params)}"
  def url(:dynamic, id, params), do: ~p"/dynamic_tabs/#{id}?#{Params.params(params)}"
end
