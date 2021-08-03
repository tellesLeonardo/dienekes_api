defmodule VerandertesLeben.OrderFunctions do
  @moduledoc """
    Modulo ordernador de listas
  """

  @spec ordernate(list) :: list
  @doc """
    Função de ordenação que subdivide uma lista até sua parte atomica e faz a concatenação em ordem
  """
  def ordernate(list) when length(list) <= 1 and is_list(list), do: list

  def ordernate(list) when is_list(list) do
    {left, right} = Enum.split(list, div(length(list), 2))
    :lists.merge(ordernate(left), ordernate(right))
  end

  def ordernate(_list), do: :invalid


end
