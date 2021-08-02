defmodule VerandertesLeben.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    # socket_ports ++
    children = [
      cowboy(),
      {VerandertesLeben, %{}}
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
        port: 4000
      ]
    }
  end
end
