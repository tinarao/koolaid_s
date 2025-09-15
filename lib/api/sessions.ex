defmodule Api.Sessions do
  require Logger
  use GenServer

  # 3 часа
  @key_ttl 60_000 * 60 * 3
  @cleanup_interval 60_000 * 10

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
    case :ets.lookup(__MODULE__, key) do
      [] ->
        false

      [{^key, {exp_time, _creator_device_id}}] ->
        System.monotonic_time(:millisecond) < exp_time
    end
  end

  def put(key, creator_device_id, ttl \\ @key_ttl) do
    exp_time = System.monotonic_time(:millisecond) + ttl
    :ets.insert(__MODULE__, {key, {exp_time, creator_device_id}})
  end

  def remove(key, device_id) do
    case :ets.lookup(__MODULE__, key) do
      [] ->
        {:error, :not_found}

      [{^key, {_exp_time, creator_device_id}}] ->
        IO.inspect(creator_device_id, label: "Creator Device ID")
        IO.inspect(device_id, label: "Device ID")

        if creator_device_id == device_id do
          :ets.delete(__MODULE__, key)
          {:ok, :deleted}
        else
          {:error, :forbidden}
        end
    end
  end

  @impl true
  def init(_) do
    :ets.new(__MODULE__, [:set, :named_table, :public, read_concurrency: true])

    Process.send_after(self(), :cleanup, @cleanup_interval)

    {:ok, %{}}
  end

  @impl true
  def handle_info(:cleanup, state) do
    Logger.info("Cleanup")
    now = System.monotonic_time(:millisecond)
    :ets.select_delete(__MODULE__, [{{:"$1", :"$2"}, [{:<, :"$2", now}], [true]}])

    Process.send_after(self(), :cleanup, @cleanup_interval)
    {:noreply, state}
  end
end
