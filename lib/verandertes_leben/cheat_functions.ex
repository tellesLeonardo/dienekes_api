defmodule VerandertesLeben.CheatFunctions do
  @moduledoc """
    Funções genericas para evitar Redundância
  """

  def timestamp(tz \\ "America/Sao_Paulo") do
    Timex.now(tz)
    |> Timex.to_unix()
  end

  def ordernate(list \\ [59.1, 54.1 ,26.0 , 93.0 , 17.0 , 77.0 ,19.0 , 31.0 , 34.0 , 100.0 , 78.0 , 20.0, 21.0, 22.0]) do
    tam =
    if length(list) > 1 do
      list
      |> Enum.chunk_every(2)
      |> Stream.map(fn item -> separate(item) end)
      |> Stream.chunk_every(1000)
      |> Task.async_stream(fn item -> unium_list(item) end, max_concurrency: 50, timeout: :infinity)
      |> Enum.to_list()

      # |>
    end

    tam
  end

  def separate([initial, final]) do
    if initial < final, do: [initial, final], else: [final, initial]
  end

  def separate(initial), do: initial

  def unium_list([elem1, elem2 | tail]) do
    return_ordenate = ordered_elements(elem1, elem2, [])

    [return_ordenate | tail]
    |> unium_list
  end

  def unium_list([ordered_elements]) do
    ordered_elements
  end


  defp ordered_elements([], [item], aux), do: valid_aux(aux,item)
  defp ordered_elements([item], [], aux ), do: valid_aux(aux,item)
  defp ordered_elements([], [], aux), do: aux

  defp ordered_elements([], [item_2 | tail2], aux ) do
    aux = valid_aux(aux, item_2)

    ordered_elements([], tail2, aux)

  end

  defp ordered_elements([item_1 | tail1], [], aux ) do

    aux = valid_aux(aux, item_1)

    ordered_elements(tail1, [], aux)
  end

  defp ordered_elements([item_1], [item_2], aux) do

    aux =
    if item_1 < item_2 do
      valid_aux(aux, item_1)
      |> valid_aux(item_2)
    else
      valid_aux(aux, item_2)
      |> valid_aux(item_1)
    end

    ordered_elements([], [], aux)
  end

  defp ordered_elements([item_1 | tail1], [item_2 | tail2], aux) do

    if item_1 < item_2 do
      aux = valid_aux(aux, item_1)

      ordered_elements(tail1, [item_2 | tail2], aux)
    else
      aux = valid_aux(aux, item_2)

      ordered_elements([item_1 | tail1], tail2, aux)
    end

  end


  defp valid_aux(aux, number) do
    return_aux =
      aux
      |> Stream.map(fn item -> if item < number, do: item, else: [number,aux] end)
      |> Enum.to_list()
      |> List.flatten()


    if number in return_aux, do: return_aux, else: return_aux ++ [number]

  end


end
