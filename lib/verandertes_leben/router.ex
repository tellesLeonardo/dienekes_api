defmodule VerandertesLeben.Router do
  @moduledoc false

  alias VerandertesLeben.Api.Load

  use Plug.Router
  use Plug.ErrorHandler

  plug(Plug.Parsers,
    parsers: [:urlencoded, {:json, json_decoder: Jason}]
  )

  plug(:match)
  plug(:dispatch)

  get "/api/order_all" do
    apply(Load, :order_all, [conn, conn.params, opts])
  end

  get "/api/order_page/:page" do
    apply(Load, :order_page, [conn, conn.params, page])
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, Jason.encode!(%{message: "Nada para ver aqui", status: false}))
  end

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(conn.status, Jason.encode!(%{message: "Nada para ver aqui", status: false}))
  end
end
