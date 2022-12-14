defmodule RateLimitWeb.PageController do
  use RateLimitWeb, :controller
  import Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def get_timestamp(conn, _params) do
    ip = conn.remote_ip
      |> Tuple.to_list
      |> Enum.join(".")
    case Hammer.check_rate("get_timestamp:#{ip}", 60_000, 60) do
      {:allow, _count} ->
        Logger.log(:info, "Rate-Limit ok, generating timestamp")
        now = DateTime.utc_now()
        conn |> json(%{timestamp: "#{now}"})
      {:deny, _} ->
        Logger.log(:info, "Rate-Limit exceeded, denying request")
        conn |> send_resp(429, "Too many requests")
    end
  end
end
