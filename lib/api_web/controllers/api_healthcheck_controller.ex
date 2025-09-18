defmodule ApiWeb.ApiHealthcheckController do
  use ApiWeb, :controller

  def healthcheck(conn, _) do
    conn |> put_status(200) |> text("Ok")
  end
end
