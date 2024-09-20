defmodule Ui.Ash.Policy.Macros do
  defmacro check_group(name, do: block) do
    module = __CALLER__.module

    if not Module.has_attribute?(module, name) do
      Module.register_attribute(module, :check_groups, persist: true, accumulate: true)
    end

    if module |> Module.get_attribute(:check_groups) |> Keyword.get(name) do
      raise CompileError,
        description: "check_group \"#{name}\" for module #{module} already defined"
    end

    Module.put_attribute(module, :check_groups, {name, [block: block]})
  end

  defmacro check_group(name) do
    module = __CALLER__.module

    module
    |> Module.get_attribute(:check_groups)
    |> Kernel.||([])
    |> Keyword.fetch(name)
    |> case do
      {:ok, block} ->
        block

      :error ->
        raise CompileError,
          description: "Unknown check_group named \"#{name}\" for module #{module}"
    end
  end
end

defmodule Ui.Resources.Resource1.Policies do
  @moduledoc false

  use Spark.Dsl.Fragment,
    of: Ash.Resource,
    authorizers: [Ash.Policy.Authorizer]

  import Ui.Ash.Policy.Macros

  policies do
    check_group :admin_and_active do
      forbid_unless actor_attribute_equals(:role, :admin)
      forbid_unless actor_attribute_equals(:active?, true)
    end

    policy action(:read) do
      # check_group :admin_and_active
      authorize_if always()
    end

    policy action(:create) do
      # check_group :admin_and_active
      authorize_if always()
    end
  end
end

defmodule Ui.Resources.Resource1 do
  @moduledoc false

  alias Ui.Resources.Resource1

  use Ash.Resource,
    domain: Ui.Resources,
    fragments: [Resource1.Policies],
    data_layer: Ash.DataLayer.Ets

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string, allow_nil?: false
    attribute :type, :string, allow_nil?: false
  end

  ets do
    private? false
  end

  policies do
  end

  actions do
    defaults [:destroy]

    read :read do
      primary? true

      pagination do
        keyset? true
      end

      prepare build(sort: {:name, :asc})
    end

    create :create do
      primary? true

      accept [:name, :type]
    end

    update :update do
      primary? true

      accept [:name, :type]
    end
  end
end
