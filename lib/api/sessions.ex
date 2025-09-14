defmodule Api.Sessions do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def generate_key do
    uuid = UUID.uuid4()

    case exists?(uuid) do
      true -> generate_key()
      false -> uuid
    end
  end

  def exists?(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def put(key) do
    GenServer.cast(__MODULE__, {:put, key})
  end

  def remove(key) do
    GenServer.cast(__MODULE__, {:remove, key})
  end

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    case Enum.member?(state, key) do
      true -> {:reply, true, state}
      false -> {:reply, false, state}
    end
  end

  @impl true
  def handle_cast({:put, key}, state) do
    {:noreply, state ++ [key]}
  end

  @impl true
  def handle_cast({:remove, key}, state) do
    new_state = Enum.filter(state, fn x -> x != key end)

    {:noreply, new_state}
  end
end
