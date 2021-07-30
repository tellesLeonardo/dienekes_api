defmodule VerandertesLeben.CheatFunctions do
  @moduledoc """
    Funções genericas para evitar Redundância
  """

  # 10000
  def route, do: "http://challenge.dienekes.com.br/api/numbers?page="

  def timestamp(tz \\ "America/Sao_Paulo") do
    Timex.now(tz)
    |> Timex.to_unix()
  end
end
