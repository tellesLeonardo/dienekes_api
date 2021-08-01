defmodule VerandertesLeben.Fetcher do
  @moduledoc """
    Fetcher para fazer a buscas de APIs
  """

  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://challenge.dienekes.com.br"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Timeout, timeout: 30_000
  plug Tesla.Middleware.Retry,
    delay: 500,
    max_retries: 10,
    max_delay: 5_000,
    should_retry: fn
      {:ok, %{status: status}} when status in [400, 500] -> true
      {:ok, _} -> false
      {:error, _} -> true
    end


    @spec get_page(integer) :: Tesla.Env.t()
    @doc """
      Faz uma requisição de api por páginas
    """
  def get_page(pag \\ 1) do
    get!("api/numbers?page=#{pag}" )
  end

end
