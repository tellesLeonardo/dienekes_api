defmodule VerandertesLeben.Router do
  use Plug.Router
  use Plug.ErrorHandler

  # Dev mode TODO
  use Plug.Debugger

  alias VerandertesLeben.Api.Load

  plug(Plug.Parsers,
    parsers: [:urlencoded, {:json, json_decoder: Jason}]
  )

  plug(:match)
  plug(:dispatch)

  # Send Messages
  post "/api/" do
    # {:ok, body, conn} = read_body(conn)

    apply(Load, :worker, [conn, conn.params, opts])
  end

  # forward("/api/device", to: Devices)
  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, %{message: "Nothing to see here"} |> Jason.encode!())
  end

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(conn.status, %{message: "Something went wrong"} |> Jason.encode!())
  end
end
