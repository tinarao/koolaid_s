defmodule ApiWeb.ApiOptionsController do
  use ApiWeb, :controller

  def options(conn, _) do
    conn |> send_resp(200, "")
  end
end
