defmodule VerandertesLeben do
  @moduledoc """
    GenServer responsável por iniciar as buscas na base de dados e persistir em tempo de execução os dados
  """

  use GenServer
  require Logger

  import VerandertesLeben.Fetcher, only: [get_page: 1]
  import VerandertesLeben.OrderFunctions, only: [ordernate: 1]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: :persistent_process)
  end


  def init(data) do
    state = Map.merge(%{return_api: [], complet: false, page: 1}, data)

    {:ok, state, {:continue, :module_opening}}
  end


  def handle_continue(:module_opening, state) do
    find_all_pages()

    {:noreply, state}
  end


  def handle_call(_event, _from, %{complet: false} = state) do
    {:reply, %{message: "sincronização de dados ainda sendo feita"}, state}
  end


  def handle_call({:desorder_page, page}, _from, %{return_api: return_api} = state) do
    numbers = Keyword.get(return_api, :"#{page}")

    {:reply, numbers, state}
  end


  def handle_call(:order, _from, %{return_api: return_api} = state) do
    numbers =
      return_api
      |> Keyword.values()
      |> List.flatten()
      |> ordernate()


    {:reply, numbers, state}
  end


  def handle_call({:order_page, page}, _from, %{return_api: return_api} = state) do
    number =
      return_api
      |> Keyword.get(:"#{page}")
      |> ordernate()

    {:reply, number, state}
  end

  
  def handle_info(
        :find_all_pages,
        %{complet: complet, page: page, return_api: return_api} = state
      ) do
    state =
      if complet do
        state
      else
        {complet, return_numbers, last_page} = step_search(page)

        return_numbers = Enum.reject(return_numbers, fn {_, i} -> [] == i end)
        return_api = return_api ++ return_numbers

        find_all_pages()

        Map.merge(state, %{complet: complet, return_api: return_api, page: last_page})
      end

    {:noreply, state}
  end

  defp find_all_pages(), do: Process.send(self(), :find_all_pages, [])

  defp step_search(init) do
    last = init + 500

    return =
      init..last
      |> Task.async_stream(fn i -> request_all_pages(i) end, max_concurrency: 250, timeout: 60_000 )
      |> Enum.to_list()
      |> Enum.reduce([], fn {:ok, x}, acc -> [x | acc] end)
      |> List.flatten()



    case List.first(return) do
      {_, []} -> {true, return, last}
      {_, _resp} -> {false, return, last}
    end
  end

  defp request_all_pages(pag) do
    return =
      pag
      |> get_page()
      |> Map.get(:body)
      |> Map.get("numbers")

    ["#{pag}": return]
  end
end
