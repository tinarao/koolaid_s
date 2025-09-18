defmodule ApiWeb.ApiSessionsController do
  use ApiWeb, :controller
  alias ApiWeb.DeviceId
  alias Api.Sessions

  def create(conn, _) do
    device_id = DeviceId.get_device_id(conn)
    key = Sessions.generate_key()
    Sessions.put(key, device_id)

    conn
    |> put_status(201)
    |> json(%{key: key})
  end

  def exists?(conn, %{"key" => key}) do
    case Sessions.exists?(key) do
      true -> conn |> put_status(200) |> text("Session exists")
      false -> conn |> put_status(404) |> text("Session does not exist")
    end
  end

  def delete(conn, %{"key" => key}) do
    device_id =
      DeviceId.get_device_id(conn)
      |> IO.inspect(label: "device_id")

    case Sessions.remove(key, device_id) do
      {:ok, :deleted} ->
        conn |> put_status(200) |> text("Deleted")

      {:error, :not_found} ->
        conn |> put_status(404) |> text("Not found")

      {:error, :forbidden} ->
        conn |> put_status(403) |> text("Forbidden")
    end
  end
end
