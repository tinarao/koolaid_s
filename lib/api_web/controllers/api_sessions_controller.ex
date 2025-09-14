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
end
