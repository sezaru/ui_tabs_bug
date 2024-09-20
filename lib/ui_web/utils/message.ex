defmodule UiWeb.Utils.Message do
  @moduledoc false

  alias Phoenix.{LiveView, LiveView.Socket, LiveComponent.CID}

  @type target :: pid | CID.t() | {module, String.t() | atom}
  @type payload :: any

  @type t :: %__MODULE__{payload: payload}
  defstruct [:payload]

  @callback handle_message(payload, socket :: Socket.t()) :: {:ok, Socket.t()}

  @optional_callbacks handle_message: 2

  def live_view do
    quote do
      use UiWeb.Utils.Message.LiveView
    end
  end

  def live_component do
    quote do
      use UiWeb.Utils.Message.LiveComponent
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  @spec send_message(target, payload) :: :ok
  def send_message(target, payload) do
    message = %__MODULE__{payload: payload}

    do_send_message(target, message)
  end

  defp do_send_message(pid, message) when is_pid(pid), do: send(pid, message)
  defp do_send_message(%CID{} = cid, message), do: LiveView.send_update(cid, __message__: message)

  defp do_send_message({module, id}, message),
    do: LiveView.send_update(module, id: id, __message__: message)
end
