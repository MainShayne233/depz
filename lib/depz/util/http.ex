defmodule Depz.Util.HTTP do

  @adapter if Mix.env == :test, do: __MODULE__.TestAdapter, else: __MODULE__.HTTPAdapter

  def get(url) do
    with true <- Code.ensure_loaded?(Tesla),
         %Tesla.Env{body: body, status: 200} <- @adapter.get(url) do
      {:ok, body}
    end
  end

  defmodule HTTPAdapter do

    def get(url), do: Tesla.get(url, headers: %{"User-Agent" => "tesla"})

  end

  defmodule TestAdapter do
    def get("https://hex.pm/api/packages/httpotion") do
      %Tesla.Env{__client__: nil, __module__: Tesla,
        body: "{\"url\":\"https://hex.pm/api/packages/httpotion\",\"updated_at\":\"2017-05-17T20:45:39.787985Z\",\"releases\":[{\"version\":\"3.0.2\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/3.0.2\"},{\"version\":\"3.0.1\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/3.0.1\"},{\"version\":\"3.0.0\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/3.0.0\"},{\"version\":\"2.2.2\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/2.2.2\"},{\"version\":\"2.2.1\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/2.2.1\"},{\"version\":\"2.2.0\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/2.2.0\"},{\"version\":\"2.1.0\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/2.1.0\"},{\"version\":\"2.0.0\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/2.0.0\"},{\"version\":\"1.0.0\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/1.0.0\"},{\"version\":\"0.2.4\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/0.2.4\"}],\"owners\":[{\"username\":\"myfreeweb\",\"url\":\"https://hex.pm/api/users/myfreeweb\",\"email\":\"floatboth@me.com\"}],\"name\":\"httpotion\",\"meta\":{\"maintainers\":[\"Greg V\",\"Aleksei Magusev\"],\"links\":{\"GitHub\":\"https://github.com/myfreeweb/httpotion\"},\"licenses\":[\"Unlicense\"],\"description\":\"Fancy HTTP client for Elixir, based on ibrowse.\"},\"inserted_at\":\"2014-07-02T17:08:09.000000Z\",\"downloads\":[{\"all\":295599},{\"day\":110},{\"week\":3495}]}",
        headers: %{"cache-control" => "public, max-age=60",
   "connection" => "keep-alive", "content-length" => "1338",
   "content-type" => "application/vnd.hex+json; charset=utf-8",
   "date" => "Sun, 09 Jul 2017 20:23:48 GMT",
   "etag" => "9e6e782cb5d71334e1d811b75b8ab7cc",
   "last-modified" => "Wed, 17 May 2017 20:45:39 GMT", "server" => "Cowboy",
   "strict-transport-security" => "max-age=31536000",
   "vary" => "accept, accept-encoding, accept-encoding", "via" => "1.1 vegur",
   "x-ratelimit-limit" => "100", "x-ratelimit-remaining" => "99",
   "x-ratelimit-reset" => "1499631840"}, method: :get, opts: [], query: [],
       status: 200, url: "https://hex.pm/api/packages/httpotion"}
    end
  end
end
