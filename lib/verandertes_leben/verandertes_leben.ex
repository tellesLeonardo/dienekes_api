defmodule VerandertesLeben.Sync do
  use GenServer
  require Logger

  def start_link(%{route: _route} = args) do
    GenServer.start_link(__MODULE__, args, name: :persistent_process )
  end

  @impl true
  def start_link(_), do: Logger.error("inicialização sem os dados necessários")


  @impl true
  def init(data) do
    state = Map.merge(%{return_api: [], complet: false, page: 1}, data)

    {:ok, state, {:continue, :module_opening}}
  end

  @impl true
  def handle_continue(:module_opening, %{route: route} = state) do
    # verifica se tem sessões duplicadas do whats_web
    find_all_pages()

    {:noreply, state}
  end


  @impl true
  def handle_call(event, _from, %{complet: false} = state ) do

    {:reply, %{message: "sincronização de dados ainda sendo feita"}, state}
  end

  @impl true
  def handle_call(:teste, _from, state ) do
    state.return_api
    # |> Keyword.values()
    |> Enum.reject(fn {_, i} -> [] == i end)
    |> Enum.count()
    |> IO.inspect()

    {:reply, :teste, state}
  end

  def handle_info(:find_all_pages, %{route: route, complet: complet,page: page,return_api: return_api} = state) do

    state =
      if complet do
        state
      else
        {complet, return_numbers,last_page} =
        step_search(page, route)



        return_api =
          return_api ++ return_numbers
          |> Enum.reject(fn {_, i} -> [] == i end)

        find_all_pages()

        state |> Map.merge(%{complet: complet,return_api: return_api,page: last_page})
      end

    {:noreply, state}
  end


  def find_all_pages(), do: Process.send(self(), :find_all_pages, [])


  def step_search(init, route) do
    last = init + 501

    return =
      init..last
      #|> Stream.take(31)
      |> Task.async_stream(fn i -> request_all_pages(route, i) end, max_concurrency: 250)
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

  defp request_all_pages(route, pag, accumulator \\ []) do
    "#{route}#{pag}"
    |> IO.inspect(label: "find_all_pages")

    url = "#{route}#{pag}"

    [ "#{pag}": request(url,[]) ]

  end

  defp request(url, headers) do
    case :hackney.request(:get, url, headers) do
      {:ok, _status, _header, ref_return} ->
        {:ok, body} = :hackney.body(ref_return)
        new_body =
          body
          |> Jason.decode!(keys: :atoms)
          |> Map.get(:numbers, [])

      {:error, _} ->
        []

       _ -> []
    end
  end
end
