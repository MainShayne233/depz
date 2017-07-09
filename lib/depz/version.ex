defmodule Depz.Version do
  alias Depz.Util.HTTP

  @hex_path "https://hex.pm/api/packages"

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
    IO.puts "Fetching latest version of " <> dep_name <> "..."
    dep_name
    |> versions
    |> case do
       {:ok, [latest_version | _rest]} ->
         IO.puts "Latest version is #{latest_version}!"
         {:ok, latest_version}
       {:error, :not_found} ->
         {:error, dep_not_found_error(dep_name)}
    end
  end


  defp versions(dep_name) do
    url = (@hex_path <>  "/" <> dep_name)
    with {:ok, response} <- HTTP.get(url) do
      versions =
        ~r/"version":("\d\.\d\.\d")/
        |> Regex.scan(response, capture: :all_but_first)
        |> Enum.map(fn [version] ->
          version |> String.replace("\"", "")
        end)
        |> Enum.sort(&(&1 >= &2))

      {:ok, versions}
    end
  end


  defp dep_not_found_error(dep_name) do
    """
    Can't find #{dep_name} via the Hex registery.
    Are you sure this package has been published to hex.pm?
    """
  end
end
