defmodule Ui.Resources.TableManagement.Column do
  @moduledoc false

  use Ash.Resource,
    data_layer: :embedded

  attributes do
    attribute :name, :atom, allow_nil?: false
    attribute :enabled?, :boolean, default: true, allow_nil?: false
  end

  actions do
    defaults [:destroy, :read]

    create :create do
      primary? true

      accept [:name, :enabled?]
    end
  end
end
