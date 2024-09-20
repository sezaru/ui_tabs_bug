defmodule UiWeb.Utils.Message.LiveView do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @behaviour UiWeb.Utils.Message

      on_mount({UiWeb.Utils.Message.LiveView, __MODULE__})

      import UiWeb.Utils.Message, only: [send_message: 2]
    end
  end

  def on_mount(module, _params, _session, socket) do
    hook =
      Phoenix.LiveView.attach_hook(
        socket,
        :message_info,
        :handle_info,
        &handle_info(module, &1, &2)
      )

    {:cont, hook}
  end

  defp handle_info(module, %UiWeb.Utils.Message{} = message, socket) do
    socket =
      case module.handle_message(message.payload, socket) do
        {:ok, %Phoenix.LiveView.Socket{} = socket} -> socket
        _ -> raise "Expected handle_message/2 to return {:ok, %Phoenix.LiveView.Socket{}}"
      end

    {:halt, socket}
  end

  defp handle_info(_module, _message, socket), do: {:cont, socket}
end
