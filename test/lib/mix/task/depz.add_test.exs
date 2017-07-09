defmodule Mix.Task.Depz.AddTest do
  use ExUnit.Case, async: true

  @example_mix_dir "./test/support/mix_exs_examples/examples"
  @expected_mix_dir "./test/support/mix_exs_examples/expected"


  test "should provide a usage prompt when run with no args" do
    assert ExUnit.CaptureIO.capture_io(fn ->
      Mix.Tasks.Depz.Add.do_run([])
    end) == """
    Usage:

    mix depz.add mix_dependency

    mix deps.add mix_dependency -v 1.2.0

    mix deps.add mix_dependency -v >=1.2.1

    """
  end


  test "should add dependency to mix_exs file for the open list case" do
    example_mix_exs = example_mix_exs_for_case("open_list")
    mix_exs = Mix.Tasks.Depz.Add.do_run(["httpotion"], example_mix_exs)
    assert mix_exs == expected_file_for_case("open_list")
  end


  test "should add dependency to mix_exs file for the empty list case" do
    example_mix_exs = example_mix_exs_for_case("empty_list")
    mix_exs = Mix.Tasks.Depz.Add.do_run(["httpotion"], example_mix_exs)
    assert mix_exs == expected_file_for_case("empty_list")
  end


  test "should add dependency to mix_exs file for the closed list case" do
    example_mix_exs = example_mix_exs_for_case("closed_list")
    mix_exs = Mix.Tasks.Depz.Add.do_run(["httpotion"], example_mix_exs)
    assert mix_exs == expected_file_for_case("closed_list")
  end


  defp expected_file_for_case(list_case) do
    @expected_mix_dir
    |> Path.join("#{list_case}_expected.exs")
    |> File.read!
  end


  defp example_mix_exs_for_case(list_case) do
    @example_mix_dir
    |> Path.join("#{list_case}_example.exs")
    |> File.read!
  end
end
