defmodule Mix.Tasks.Depz.Add do
  use Mix.Task
  alias Depz.{Parser, Version}

  def run([]) do
    Mix.Task.run("app.start", [])
    Mix.Shell.IO.info """
    Usage:

    mix depz.add mix_dependency

    mix deps.add mix_dependency -v 1.2.0

    mix deps.add mix_dependency -v >=1.2.1
    """
  end


  def run(args) do
    with {:ok, mix_exs} <- File.read("./mix.exs"),
         {:ok, updated_file} <- do_run(args, mix_exs) do

      File.write!("mix.exs", updated_file)
    else
      {:error, error} ->
        Mix.Shell.IO.error("Something went wrong: #{inspect error}")
    end
  end


  def do_run([dep_name | options], mix_exs) do
    with {:ok, list_case} <- Parser.parse_case(mix_exs),
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

      Mix.Shell.IO.info("Added #{inspect(new_dep)} to mix.exs")

      file =
        [
          first_chunk,
          deps_string,
          last_chunk,
        ]
        |> Enum.join("\n")

      {:ok, file}
    end
  end


  defp deps_list_string(deps, spacing, :empty_list) do
    deps
    |> deps_list_string(spacing, :open_list)
  end


  defp deps_list_string(deps, spacing, :closed_list) do
    [first_dep | deps] = deps
    {last_dep, deps} = deps |> List.pop_at(-1)

    string_deps =
      deps
      |> Enum.map(fn dep ->
        "\n" <> String.duplicate(" ", 2 * spacing + 1) <> inspect(dep) <> ","
      end)
      |> Enum.join("\n")

    [
      String.duplicate(" ", 2 * spacing),
      "[",
      inspect(first_dep),
      ",",
      string_deps,
      "\n",
      String.duplicate(" ", 2 * spacing + 1),
      inspect(last_dep),
      "]"
    ]
    |> Enum.join
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
