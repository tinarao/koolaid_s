defmodule ApiWeb.ApiSessionsController do
  use ApiWeb, :controller
  alias Api.Sessions

  def create(conn, _) do
    key = Sessions.generate_key()
    Sessions.put(key)

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
end
