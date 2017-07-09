defmodule Depz.Version do

  @hex_path "https://hex.pm/api/packages"

  @headers [{'User-Agent', 'httpc'}]


  @doc """
  Returns the user-stated version, or the latest version if not specified
  """
  @spec get_version(atom, list) :: {:ok, String.t} | {:error, String.t}
  def get_version(dep_name, options \\ []) do
    options
    |> user_specified_version
    |> case do
      {:ok, version} -> {:ok, version}
      {:error, :not_specified} -> get_latest_version(dep_name)
    end
  end


  defp user_specified_version(options) do
    options
    |> Enum.find_index(&( &1 == "-v" ))
    |> case do
      nil -> {:error, :not_specified}
      index -> {:ok, options |> Enum.at(index + 1)}
    end
  end


  defp get_latest_version(dep_name) do
    with {:ok, [latest_version | _rest]} <- versions(dep_name) do
      {:ok, latest_version}
    end
  end


  defp versions(dep_name) do
    url = (@hex_path <>  "/" <> dep_name) |> String.to_charlist
    with {:ok, response} <- get(url) do
      versions =
        response
        |> Poison.decode!
        |> Map.get("releases")
        |> Enum.map(fn %{"version" => version} -> version end)
        |> Enum.sort
        |> Enum.reverse
      {:ok, versions}
    end
  end


  defp get(url) do
    with {:ok, {{_, 200, 'OK'}, _meta, response}} <- do_get(url) do
      {:ok, response |> to_string}
    end
  end


  defp do_get(url) do
    :httpc.request(:get, {url, @headers}, [], [])
  end
end
