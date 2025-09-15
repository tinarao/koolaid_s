defmodule ApiWeb.DeviceId do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    key = create_device_id(conn)
    assign(conn, :device_id, key)
  end

  def get_device_id(conn) do
    conn.assigns.device_id
  end

  defp get_remote_ip(conn) do
    conn.remote_ip
    |> Tuple.to_list()
    |> Enum.join(".")
  end

  defp get_user_agent(conn) do
    conn
    |> get_req_header("user-agent")
    |> Enum.at(0)
  end

  defp create_device_id(conn) do
    raw_str = get_remote_ip(conn) <> get_user_agent(conn)

    :crypto.hash(:sha256, raw_str)
    |> Base.encode64()
  end
end
