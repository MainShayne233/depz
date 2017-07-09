defmodule Depz.Parser do

  @doc """
  Returns a list of the deps in the mix.exs file
  """
  @spec parse_deps(String.t) :: {:ok, [{atom, [atom | String.t]}]} | {:error, String.t}
  def parse_deps(file) do
    with {:ok, deps_section} <- deps_section(file) do
      deps =
        ~r/\[(.|\n)*\]/
        |> Regex.scan(deps_section)
        |> Enum.at(0)
        |> Enum.at(0)
        |> Code.eval_string
        |> elem(0)

      {:ok, deps}
    end
  end


  @doc """
  Returns the correct deps list case for the given file, if it can be parsed
  """
  @spec parse_case(String.t) :: {:ok, atom} | {:error, String.t}
  def parse_case(file) do
    with {:ok, deps_section} <- deps_section(file) do
      check_for_empty_list_case(deps_section)
    end
  end


  @doc """
  Returns the spacing used for the mix.exs file
  """
  @spec parse_spacing(String.t) :: {:ok, number} | {:error, String.t}
  def parse_spacing(file) do
    with {:ok, deps_start_index.._deps_end_index} <- deps_range(file) do
      spaces =
        file
        |> String.split("\n")
        |> Enum.at(deps_start_index)
        |> String.split("defp")
        |> Enum.at(0)
        |> String.length
      {:ok, spaces}
    end
  end


  defp check_for_empty_list_case(file) do
    file
    |> String.split("\n")
    |> Enum.at(1)
    |> String.replace(" ", "")
    |> case do
      "[]" -> {:ok, :empty_list}
      _other -> check_for_collapsed_list_case(file)
    end
  end


  defp check_for_collapsed_list_case(file) do
    file
    |> String.split("\n")
    |> Enum.at(1)
    |> Kernel.=~(~r/\[\s*{.*}/)
    |> case do
      true -> {:ok, :collapsed_list}
      false -> check_for_open_list_case(file)
    end
  end


  defp check_for_open_list_case(file) do
    file
    |> String.split("\n")
    |> Enum.at(1)
    |> String.replace(" ", "")
    |> case do
      "[" -> {:ok, :open_list}
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


  def deps_range(file) do
    lines = file |> String.split("\n")
    with {:ok, start_index} <- find_matching_line(lines, deps_start_matchers()),
         {:ok, end_index} <- find_matching_line(lines, deps_end_matcher(), start_index) do

      {:ok, start_index..end_index}
    end
  end


  defp find_matching_line(lines, matchers, start_index \\ 0)
  defp find_matching_line(lines, matchers, start_index) when matchers |> is_list do
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


  defp find_matching_line(lines, matcher, start_index) when matcher |> is_function do
    lines
    |> Enum.slice(start_index..-1)
    |> Enum.find_index(fn line ->
      matcher.(line)
    end)
    |> case do
      nil -> {:error, "No line for matchers"}
      index -> {:ok, index + start_index}
    end
  end

  defp deps_start_matchers do
    [
      "defp deps",
    ]
  end

  defp deps_end_matcher do
    fn line ->
      String.replace(line, " ", "") == "end"
    end
  end
end
