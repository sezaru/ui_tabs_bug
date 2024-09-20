defmodule Ui.Resources.TableManagement do
  @moduledoc false

  alias Ui.Resources.TableManagement

  use Ash.Resource,
    domain: Ui.Resources,
    data_layer: Ash.DataLayer.Mnesia

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string, allow_nil?: false

    attribute :enabled_columns, {:array, :atom} do
      allow_nil? false

      default []

      constraints remove_nil_items?: true
    end

    attribute :columns_order, {:array, :atom} do
      allow_nil? false

      default []

      constraints remove_nil_items?: true
    end

    attribute :rows_per_page, :integer

    timestamps()
  end

  calculations do
    alias TableManagement.Calculations

    calculate :columns, {:array, TableManagement.Column}, Calculations.Columns
  end

  identities do
    identity :unique_name, [:name], pre_check_with: Ui.Resources
  end

  actions do
    alias TableManagement.Actions

    defaults [:read, :destroy]

    read :get_by_name do
      alias Actions.GetByName.Preparations

      get? true
      transaction? true

      argument :name, :string, allow_nil?: false
      argument :default_columns, {:array, :atom}, allow_nil?: false
      argument :default_rows_per_page, :integer, allow_nil?: false

      prepare Preparations.CreateIfNil

      filter expr(name == ^arg(:name))

      prepare build(limit: 1, sort: {:updated_at, :desc}, load: :columns)
    end

    create :create do
      accept [:name, :enabled_columns, :columns_order, :rows_per_page]
    end

    create :create_columns do
      upsert? true
      upsert_identity :unique_name
      upsert_fields [:enabled_columns, :columns_order]

      accept [:name, :enabled_columns, :columns_order]
    end

    create :create_rows_per_page do
      upsert? true
      upsert_identity :unique_name
      upsert_fields [:rows_per_page]

      accept [:name, :rows_per_page]
    end

    update :update_columns do
      accept [:name, :enabled_columns, :columns_order]
    end

    update :update_rows_per_page do
      accept [:name, :rows_per_page]
    end
  end
end
