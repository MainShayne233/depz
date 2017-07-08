defmodule Depz.Parser do

  @deps_start_indicators [
    "defp deps",
  ]

  @deps_end_indicators [
    "end",
  ]

  @doc """
  Should return the correct case for the given file
  """
  @spec parse_case(String.t) :: {:ok, atom} | {:error, String.t}
  def parse_case(file) do
    with {:ok, deps_section} <- deps_section(file) do
      check_for_empty_list_case(deps_section)
    end
  end


  defp check_for_empty_list_case(file) do
    file
    |> String.split("\n")
    |> Enum.at(1)
    |> String.replace(" ", "")
    |> case do
      "[]" -> {:ok, :empty_list}
      _other -> {:error, "Could not identify case"}
    end
  end


  defp deps_section(file) do
    with {:ok, deps_range} <- deps_range(file) do
      section =
        file
        |> String.split("\n")
        |> Enum.slice(deps_range)
        |> Enum.join("\n")
      {:ok, section}
    end
  end


  defp deps_range(file) do
    lines = file |> String.split("\n")
    with {:ok, start_index} <- find_matching_line(lines, @deps_start_indicators),
         {:ok, end_index} <- find_matching_line(lines, @deps_end_indicators, start_index) do

      {:ok, start_index..end_index}
    end
  end


  defp find_matching_line(lines, matchers, start_index \\ 0) do
    lines
    |> Enum.slice(start_index..-1)
    |> Enum.find_index(fn line ->
      matchers
      |> Enum.any?(fn matcher ->
        line =~ matcher
      end)
    end)
    |> case do
      nil -> {:error, "No line for matchers"}
      index -> {:ok, index + start_index}
    end
  end
end
