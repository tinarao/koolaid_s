defmodule ApiWeb.SessionChannel do
  use ApiWeb, :channel
  alias Api.Sessions

  @impl true
  def join("session:" <> session_key, _payload, socket) do
    case Sessions.exists?(session_key) do
      true -> {:ok, socket}
      false -> {:error, %{reason: "Сессия не найдена"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (session:lobby).
  @impl true
  def handle_in("broadcast", %{"message" => message}, socket) do
    broadcast(socket, "broadcast", %{message: message})
    {:noreply, socket}
  end
end
