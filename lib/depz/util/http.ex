defmodule Depz.Util.HTTP do

  @adapter if Mix.env == :test, do: __MODULE__.TestAdapter, else: __MODULE__.HTTPAdapter

  def get(url) do
    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <- @adapter.get(url) do
      {:ok, body}
    end
  end

  defmodule HTTPAdapter do

    def get(url), do: HTTPoison.get(url)

  end

  defmodule TestAdapter do
    def get("https://hex.pm/api/packages/httpotion") do
      {:ok, %HTTPoison.Response{body: "{\"url\":\"https://hex.pm/api/packages/httpotion\",\"updated_at\":\"2017-05-17T20:45:39.787985Z\",\"releases\":[{\"version\":\"3.0.2\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/3.0.2\"},{\"version\":\"3.0.1\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/3.0.1\"},{\"version\":\"3.0.0\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/3.0.0\"},{\"version\":\"2.2.2\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/2.2.2\"},{\"version\":\"2.2.1\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/2.2.1\"},{\"version\":\"2.2.0\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/2.2.0\"},{\"version\":\"2.1.0\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/2.1.0\"},{\"version\":\"2.0.0\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/2.0.0\"},{\"version\":\"1.0.0\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/1.0.0\"},{\"version\":\"0.2.4\",\"url\":\"https://hex.pm/api/packages/httpotion/releases/0.2.4\"}],\"owners\":[{\"username\":\"myfreeweb\",\"url\":\"https://hex.pm/api/users/myfreeweb\",\"email\":\"floatboth@me.com\"}],\"name\":\"httpotion\",\"meta\":{\"maintainers\":[\"Greg V\",\"Aleksei Magusev\"],\"links\":{\"GitHub\":\"https://github.com/myfreeweb/httpotion\"},\"licenses\":[\"Unlicense\"],\"description\":\"Fancy HTTP client for Elixir, based on ibrowse.\"},\"inserted_at\":\"2014-07-02T17:08:09.000000Z\",\"downloads\":[{\"all\":295599},{\"day\":110},{\"week\":3495}]}",
  headers: [{"Connection", "keep-alive"}, {"Server", "Cowboy"},
   {"Date", "Sun, 09 Jul 2017 19:46:06 GMT"}, {"Content-Length", "1338"},
   {"Content-Type", "application/vnd.hex+json; charset=utf-8"},
   {"Cache-Control", "public, max-age=60"},
   {"Strict-Transport-Security", "max-age=31536000"},
   {"X-Ratelimit-Limit", "100"}, {"X-Ratelimit-Remaining", "99"},
   {"X-Ratelimit-Reset", "1499629620"},
   {"Etag", "9e6e782cb5d71334e1d811b75b8ab7cc"},
   {"Last-Modified", "Wed, 17 May 2017 20:45:39 GMT"},
   {"Vary", "accept, accept-encoding, accept-encoding"}, {"Via", "1.1 vegur"}],
  request_url: "https://hex.pm/api/packages/httpotion", status_code: 200}}
    end
  end
end
