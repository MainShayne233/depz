defmodule Depz.Util.HTTP do

  @adapter if Mix.env == :test, do: __MODULE__.TestAdapter, else: __MODULE__.HTTPAdapter

  def get(url) do
    with {:ok, {{_, 200, 'OK'}, _, body}} <- @adapter.get(url) do
      {:ok, body |> to_string}
    end
  end

  defmodule HTTPAdapter do

    def get(url) do
      url = String.to_charlist(url)
      :httpc.request(:get, {url, [{'User-Agent', 'httpc'}]}, [], [])
    end
  end

  defmodule TestAdapter do
    def get("https://hex.pm/api/packages/httpotion") do
      {:ok,
       {{'HTTP/1.1', 200, 'OK'},
        [{'cache-control', 'public, max-age=60'}, {'connection', 'keep-alive'},
         {'date', 'Sun, 09 Jul 2017 22:06:36 GMT'}, {'via', '1.1 vegur'},
         {'etag', '2a5dca54fcff28015cd9732dc07b7b71'}, {'server', 'Cowboy'},
         {'vary', 'accept, accept-encoding, accept-encoding'},
         {'content-length', '2061'},
         {'content-type', 'application/vnd.hex+json; charset=utf-8'},
         {'last-modified', 'Sun, 15 Jan 2017 01:34:31 GMT'},
         {'strict-transport-security', 'max-age=31536000'},
         {'x-ratelimit-limit', '100'}, {'x-ratelimit-remaining', '99'},
         {'x-ratelimit-reset', '1499638020'}],
        '{"url":"https://hex.pm/api/packages/poison","updated_at":"2017-01-15T01:34:31.327060Z","releases":[{"version":"3.1.0","url":"https://hex.pm/api/packages/poison/releases/3.1.0"},{"version":"3.0.0","url":"https://hex.pm/api/packages/poison/releases/3.0.0"},{"version":"2.2.0","url":"https://hex.pm/api/packages/poison/releases/2.2.0"},{"version":"2.1.0","url":"https://hex.pm/api/packages/poison/releases/2.1.0"},{"version":"2.0.1","url":"https://hex.pm/api/packages/poison/releases/2.0.1"},{"version":"2.0.0","url":"https://hex.pm/api/packages/poison/releases/2.0.0"},{"version":"1.5.2","url":"https://hex.pm/api/packages/poison/releases/1.5.2"},{"version":"1.5.1","url":"https://hex.pm/api/packages/poison/releases/1.5.1"},{"version":"1.5.0","url":"https://hex.pm/api/packages/poison/releases/1.5.0"},{"version":"1.4.0","url":"https://hex.pm/api/packages/poison/releases/1.4.0"},{"version":"1.3.1","url":"https://hex.pm/api/packages/poison/releases/1.3.1"},{"version":"1.3.0","url":"https://hex.pm/api/packages/poison/releases/1.3.0"},{"version":"1.2.1","url":"https://hex.pm/api/packages/poison/releases/1.2.1"},{"version":"1.2.0","url":"https://hex.pm/api/packages/poison/releases/1.2.0"},{"version":"1.1.1","url":"https://hex.pm/api/packages/poison/releases/1.1.1"},{"version":"1.1.0","url":"https://hex.pm/api/packages/poison/releases/1.1.0"},{"version":"1.0.3","url":"https://hex.pm/api/packages/poison/releases/1.0.3"},{"version":"1.0.2","url":"https://hex.pm/api/packages/poison/releases/1.0.2"},{"version":"1.0.1","url":"https://hex.pm/api/packages/poison/releases/1.0.1"},{"version":"1.0.0","url":"https://hex.pm/api/packages/poison/releases/1.0.0"}],"owners":[{"username":"devinus","url":"https://hex.pm/api/users/devinus","email":"devin@devintorr.es"}],"name":"poison","meta":{"maintainers":["Devin Torres"],"links":{"GitHub":"https://github.com/devinus/poison"},"licenses":["CC0-1.0"],"description":"An incredibly fast, pure Elixir JSON library"},"inserted_at":"2014-08-20T04:43:51.000000Z","downloads":[{"week":38466},{"all":3272561},{"day":2361}]}'}}
    end
  end
end
