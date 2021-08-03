defmodule VerandertesLeben.Api.Load do
  @moduledoc """
    Concentra toda a parte logica das APIs criadas
  """

  import Plug.Conn
  require Logger

  def order_all(conn, _body, _opts) do
    Logger.info("#{inspect(__MODULE__)} chamada de todas as paginas")

    numbers = GenServer.call(:persistent_process, :order, 60_000)

    return = Jason.encode!(%{status: true, numbers: numbers})

    send_resp(conn, 200, return)
  end

  def order_page(conn, _body, page) do
    Logger.info("#{inspect(__MODULE__)} chamada da pagina: #{page}")

    numbers = GenServer.call(:persistent_process, {:order_page, page}, 30_000)

    return = Jason.encode!(%{status: true, numbers: numbers, page: page})

    send_resp(conn, 200, return)
  end
end
