defmodule VerandertesLebenTest.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias VerandertesLeben.Router

  @opts Router.init([])

  describe "Validando o envio da api" do
    test "retorno de uma página ordenada" do

      {body_decode, status} = request_waiting_finish("/api/order_page/1")

      # Assert the response and status
      assert status == 200
      assert valid_body(body_decode)
    end

    test "retorno de todas páginas" do

      {body_decode, status} = request_waiting_finish("/api/order_all")

      # Assert the response and status
      assert status == 200
      assert valid_body(body_decode)
    end


    test "comparação do retorno das páginas" do

      {body_decode, status} = request_waiting_finish("/api/order_page/1")

      numbers_my_order = Map.get(body_decode, "numbers")

      numbers_sorted = Enum.sort(GenServer.call(:persistent_process, {:desorder_page, 1}, 30_000))


      # Assert the response and status
      assert status == 200
      assert numbers_my_order == numbers_sorted
    end


  end


  def valid_body(%{"status" => _status, "numbers" => _numbers}), do: true
  def valid_body(_resp), do: false

  def request_waiting_finish(route) do

    conn = Router.call(conn(:get, route, %{}), @opts)

    case Jason.decode!(conn.resp_body) do
      %{"numbers" => %{"message" => "sincronização de dados ainda sendo feita"}, "status" => _status} ->

        :timer.sleep(1_500)
        request_waiting_finish(route)

      %{"status" => _status, "numbers" => _numbers} = resp -> {resp, conn.status}
    end
  end


end
