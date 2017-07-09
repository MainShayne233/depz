defmodule Mix.Tasks.Depz.Add do
  use Mix.Task
  alias Depz.{Parser, Version}

  def run([]) do
    Mix.Shell.IO.info """
    Usage:

    mix depz.add mix_dependency

    mix deps.add mix_dependency -v 1.2.0

    mix deps.add mix_dependency -v >=1.2.1
    """
  end


  def run([dep_name | options]) do
    with {:ok, mix_exs} <- File.read("./mix.exs"),
         {:ok, list_case} <- Parser.parse_case(mix_exs),
         {:ok, spacing} <- Parser.parse_spacing(mix_exs),
         {:ok, deps} <- Parser.parse_deps(mix_exs),
         {:ok, deps_start_index..deps_end_index} <- Parser.deps_range(mix_exs),
         {:ok, version} <- Version.get_version(dep_name, options) do

      new_dep = {String.to_atom(dep_name), "~> " <> version}
      updated_deps = deps ++ [new_dep]
      deps_string = deps_list_string(updated_deps, spacing, list_case)

      lines = mix_exs |> String.split("\n")

      first_chunk =
        lines
        |> Enum.slice(0..deps_start_index)
        |> Enum.join("\n")

      last_chunk =
        lines
        |> Enum.slice(deps_end_index..-1)
        |> Enum.join("\n")

       updated_mix_exs =
         (first_chunk <> "\n" <> deps_string <> "\n" <> last_chunk)

       File.write!("./mix.exs", updated_mix_exs)
    end
  end


  defp deps_list_string(deps, spacing, :empty_list) do
    deps
    |> deps_list_string(spacing, :open_list)
  end


  defp deps_list_string([first_dep | deps], spacing, :collapsed_list) do
    {last_dep, mid_deps} = deps |> List.pop_at(-1)
    mid_deps_string =
      mid_deps
      |> Enum.join(",\n")
    """
    [#{first_dep},
     #{mid_deps_string}
     #{last_dep}]
    """
  end


  defp deps_list_string(deps, spacing, :open_list) do
    string_deps =
      deps
      |> Enum.map(fn dep ->
        String.duplicate(" ", spacing) <> inspect(dep) <> ","
      end)

    ["["]
    |> Enum.concat(string_deps)
    |> Enum.concat(["]"])
    |> Enum.map(fn line ->
      String.duplicate(" ", 2 * spacing) <> line
    end)
    |> Enum.join("\n")
  end
end
