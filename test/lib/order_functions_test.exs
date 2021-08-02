defmodule VerandertesLebenTest.OrderFunctionsTest do
  use ExUnit.Case

  import VerandertesLeben.OrderFunctions, only: [ordernate: 1]
  doctest VerandertesLeben.OrderFunctions

  describe "Ordenando dados em sequência" do

    test "teste de ordenar multiplos dados" do
      return = ordernate([11.4, 1.3, 90.0, 10.5, 2.5, 2.6, 1.4])
      assert return == [1.3,1.4,2.5,2.6,10.5, 11.4,90.0]
    end

    test "teste de ordenar um único dado" do
      return = ordernate([777])
      assert return == [777]
    end

    test "teste de tratamento de error na ordenação" do
      return = ordernate("ordene-me")
      assert return == :invalid
    end

  end
end
