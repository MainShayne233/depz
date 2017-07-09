defmodule Mix.Task.Depz.AddTest do
  use ExUnit.Case, async: true

  @example_mix_dir "./test/support/mix_exs_examples/examples"
  @expected_mix_dir "./test/support/mix_exs_examples/expected"

  import ExUnit.CaptureIO


  test "should provide a usage prompt when run with no args" do
    assert ExUnit.CaptureIO.capture_io(fn ->
      Mix.Tasks.Depz.Add.run([])
    end) == """
    Usage:

    mix depz.add mix_dependency

    mix deps.add mix_dependency -v 1.2.0

    mix deps.add mix_dependency -v >=1.2.1

    """
  end


  test "should add dependency to mix_exs file for the open list case" do
    example_mix_exs = example_mix_exs_for_case("open_list")
    assert capture_io(fn ->
      {:ok, mix_exs} = Mix.Tasks.Depz.Add.do_run(["httpotion"], example_mix_exs)
      assert mix_exs == expected_file_for_case("open_list")
    end) == """
    Fetching latest version of httpotion...
    Latest version is 3.1.0!
    Added {:httpotion, "~> 3.1.0"} to mix.exs
    """
  end


  test "should add dependency to mix_exs file for the empty list case" do
    example_mix_exs = example_mix_exs_for_case("empty_list")
    assert capture_io(fn ->
      {:ok, mix_exs} = Mix.Tasks.Depz.Add.do_run(["httpotion"], example_mix_exs)
      assert mix_exs == expected_file_for_case("empty_list")
    end) == """
    Fetching latest version of httpotion...
    Latest version is 3.1.0!
    Added {:httpotion, "~> 3.1.0"} to mix.exs
    """
  end


  test "should add dependency to mix_exs file for the closed list case" do
    example_mix_exs = example_mix_exs_for_case("closed_list")
    assert capture_io(fn ->
      {:ok, mix_exs} = Mix.Tasks.Depz.Add.do_run(["httpotion"], example_mix_exs)
      assert mix_exs == expected_file_for_case("closed_list")
    end) == """
    Fetching latest version of httpotion...
    Latest version is 3.1.0!
    Added {:httpotion, "~> 3.1.0"} to mix.exs
    """
  end


  test "should let user specify version of dep with -v flag" do
    example_mix_exs = example_mix_exs_for_case("open_list")
    assert capture_io(fn ->
      Mix.Tasks.Depz.Add.do_run(["httpotion", "-v", "3.0.0"], example_mix_exs)
    end) == """
    Added {:httpotion, "~> 3.0.0"} to mix.exs
    """
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
