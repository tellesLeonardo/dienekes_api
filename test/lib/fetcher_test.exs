defmodule VerandertesLebenTest.FetcherTest do
  use ExUnit.Case
  doctest VerandertesLeben.Fetcher

  describe "Consumindo api" do
    test "teste de busca de dados" do
      return = VerandertesLeben.Fetcher.get_page(1)
      assert return.status == 200
    end
  end
end
