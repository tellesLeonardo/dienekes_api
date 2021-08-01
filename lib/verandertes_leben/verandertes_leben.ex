defmodule VerandertesLeben.Sync do
  use GenServer
  require Logger

  alias VerandertesLeben.Fetcher
  import VerandertesLeben.CheatFunctions, only: [ordernate: 1]

  def start_link( args) do
    GenServer.start_link(__MODULE__, args, name: :persistent_process )
  end


  @impl true
  def init(data) do
    state = Map.merge(%{return_api: [], complet: false, page: 1}, data)

    {:ok, state, {:continue, :module_opening}}
  end

  @impl true
  def handle_continue(:module_opening, state) do
    # verifica se tem sessões duplicadas do whats_web
    find_all_pages()

    {:noreply, state}
  end

  @impl true
  def handle_call(_event, _from, %{complet: false} = state ) do

    {:reply, %{message: "sincronização de dados ainda sendo feita"}, state}
  end

  @impl true
  def handle_call(:get_state, _from, state ) do
    {:reply,  state, state}
  end


  @impl true
  def handle_call(:order, _from, %{return_api: return_api} = state ) do
    numbers =
      return_api
      |> Enum.map(fn {_, item} -> item end)
      |> List.flatten()
      |> Stream.chunk_every(111323)
      |> Task.async_stream(fn item -> Sort.mergesort(item) end, max_concurrency: 50, timeout: :infinity)
      |> Enum.to_list
      |> Keyword.values()

    {:reply,  numbers, state}
  end


  @impl true
  def handle_call(:teste, _from, state ) do
    state.return_api
    |> Enum.reject(fn {_, i} -> [] == i end)
    |> Enum.count()
    |> IO.inspect()

    {:reply, :teste, state}
  end

  @impl true
  def handle_info(:find_all_pages, %{complet: complet,page: page,return_api: return_api} = state) do

    state =
      if complet do

        state
      else
        {complet, return_numbers,last_page} =
        step_search(page)

        return_numbers = Enum.reject(return_numbers, fn {_, i} -> [] == i end)
        return_api = return_api ++ return_numbers

        find_all_pages()

        state |> Map.merge(%{complet: complet,return_api: return_api,page: last_page})
      end

    {:noreply, state}
  end


  def find_all_pages(), do: Process.send(self(), :find_all_pages, [])


  def step_search(init) do
    last = init + 500

    return =
      init..last
      |> Task.async_stream(fn i -> request_all_pages( i) end, max_concurrency: 250)
      |> Enum.to_list()
      |> Enum.reduce([], fn {:ok, x}, acc -> [x | acc] end)
      |> List.flatten()


    return
    |> List.first()
    |> case do
      {_, []} ->  {true, return,last}

      {_, _resp} -> {false, return,last}

    end
  end

  defp request_all_pages(pag) do
    IO.inspect(pag, label: "requistiando os testes")
    return =
      Fetcher.get_page(pag)
      |> Map.get(:body)
      |> Map.get("numbers")

    [ "#{pag}": return ]

  end

end
