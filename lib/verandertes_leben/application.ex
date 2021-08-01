defmodule VerandertesLeben.Application do
  @moduledoc false

  use Application

  import VerandertesLeben.CheatFunctions, only: [timestamp: 0]

  def start(_type, _args) do
    # socket_ports ++
    children = [
      cowboy(),
      {VerandertesLeben.Sync, %{timestamp_init: timestamp()} }
    ]

    opts = [strategy: :one_for_one, name: SocketServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cowboy do
    {
      Plug.Cowboy,
      ref: :API_4000,
      scheme: :http,
      plug: VerandertesLeben.Router,
      options: [
        # dispatch: dispatch(),
        port: 4000
      ]
    }
  end
end
