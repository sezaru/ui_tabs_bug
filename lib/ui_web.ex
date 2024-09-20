defmodule UiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use UiWeb, :controller
      use UiWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: UiWeb.Layouts]

      import Plug.Conn
      use Gettext, backend: UiWeb.Gettext

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {UiWeb.Layouts, :app}

      use UiWeb.Utils.Message, :live_view

      unquote(html_helpers())

      unquote(live_component_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      use UiWeb.Utils.Message, :live_component

      unquote(html_helpers())

      unquote(live_component_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component, global_prefixes: ~w(ui-)

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())

      unquote(component_helpers())
    end
  end

  defp live_component_helpers do
    quote do
      unquote(component_helpers())

      def ok(socket), do: {:ok, socket}
      def ok(socket, opts), do: {:ok, socket, opts}

      def no_reply(socket), do: {:noreply, socket}
      def no_reply(socket, opts), do: {:noreply, socket, opts}

      @spec push_exec(Phoenix.LiveView.Socket.t(), String.t(), Keyword.t()) :: Phoenix.LiveView.Socket.t()
      def push_exec(socket, attribute, opts \\ []) do
        to = Keyword.fetch!(opts, :to)

        payload = %{to: to, attr: attribute} |> dbg()

        push_event(socket, "js-exec", payload)
      end
    end
  end

  defp component_helpers do
    quote do
      def slot_assigned?([]), do: false
      def slot_assigned?(_), do: true

      def assert_single_slot!([]), do: :ok
      def assert_single_slot!([_]), do: :ok

      def assert_single_slot!([first_slot, _ | _]) do
        %{__slot__: slot_name} = first_slot

        raise "Slot #{inspect(slot_name)} should contain only a single slot!"
      end

      def get_slot_attr(slot, attribute, default \\ nil)

      def get_slot_attr(slot, attribute, default) when is_map(slot),
        do: Map.get(slot, attribute, default)

      def get_slot_attr([slot], attribute, default), do: get_slot_attr(slot, attribute, default)
      def get_slot_attr([], _, default), do: default
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import UiWeb.CoreComponents
      use Gettext, backend: UiWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: UiWeb.Endpoint,
        router: UiWeb.Router,
        statics: UiWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
