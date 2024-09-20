defmodule UiWeb.Utils.Message.LiveComponent do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @behaviour UiWeb.Utils.Message

      @before_compile UiWeb.Utils.Message.LiveComponent

      import UiWeb.Utils.Message, only: [send_message: 2]
    end
  end

  defmacro __before_compile__(env), do: [wrap_update_function(env)]

  defp wrap_update_function(env) do
    if Module.defines?(env.module, {:update, 2}) do
      wrap_with_update_defined()
    else
      wrap_without_update_defined()
    end
  end

  defp wrap_with_update_defined do
    quote do
      defoverridable update: 2

      def update(%{__message__: %UiWeb.Utils.Message{} = message} = assigns, socket) do
        reply = UiWeb.Utils.Message.LiveComponent.__handle_message__(__MODULE__, socket, message)

        {:ok, reply}
      end

      def update(assigns, socket), do: super(assigns, socket)
    end
  end

  defp wrap_without_update_defined do
    quote do
      def update(%{__message__: %UiWeb.Utils.Message{} = message} = assigns, socket) do
        reply = UiWeb.Utils.Message.LiveComponent.__handle_message__(__MODULE__, socket, message)

        {:ok, reply}
      end

      def update(assigns, socket), do: {:ok, Phoenix.Component.assign(socket, assigns)}
    end
  end

  def __handle_message__(module, socket, %UiWeb.Utils.Message{} = message) do
    case module.handle_message(message.payload, socket) do
      {:ok, %Phoenix.LiveView.Socket{} = socket} -> socket
      _ -> raise "Expected handle_message/2 to return {:ok, %Phoenix.LiveView.Socket{}}"
    end
  end
end
