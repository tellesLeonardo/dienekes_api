defmodule VerandertesLebenTest.Api.LoadTest do
  use ExUnit.Case
  use Plug.Test


  alias VerandertesLeben.Api.Load
  doctest VerandertesLeben.Api.Load

  @base "/api"
  # @options Router.init([])
  @options []


  describe "Validando o envio da api" do

    test "teste buscando uma página" do
      return =
        :get |> conn("#{@base}/order_page/1", %{}) |> Router.call(@options)
        |> IO.inspect()

      assert return == 200
    end

    test "teste buscando todas as páginas" do
      return =
        :get |> conn("#{@base}/order_page/1", %{}) |> Router.call(@options)
        |> IO.inspect()

      assert return == 200
    end

  end

end
