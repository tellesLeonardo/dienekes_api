defmodule VerandertesLeben.Api.Load do
  import Plug.Conn
  require Logger

  def worker(conn, _body, _opts) do
    Logger.info("#{inspect(__MODULE__)} chamda de função")
    return = %{status: false, working: true} |> Jason.encode!()
    send_resp(conn, 200, return)
  end
end
