defmodule Mix.Task.Depz.AddTest do
  use ExUnit.Case, async: true

  @test_app_path "./test_app"

  setup do
    create_test_app_directory()
    enter_test_app_directory()
    on_exit fn ->
      leave_test_app_directory()
      remove_test_app_directory()
    end
  end


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
    Mix.Tasks.Depz.Add.run(["httpotion"])
    mix_exs = File.read!("./mix.exs")
    assert mix_exs == expected_open_list_mix_exs_file()
  end


  test "should add dependency to mix_exs file for the empty list case" do
    Mix.Tasks.Depz.Add.run(["httpotion"])
    mix_exs = File.read!("./mix.exs")
    assert mix_exs == expected_empty_list_mix_exs_file()
  end


  defp create_test_app_directory do
    System.cmd("mkdir", [@test_app_path])
    enter_test_app_directory()
    File.write!("mix.exs", sample_open_list_mix_exs_file())
    leave_test_app_directory()
  end


  defp enter_test_app_directory do
    File.cd!(@test_app_path)
  end


  defp leave_test_app_directory do
    File.cd!("..")
  end


  defp remove_test_app_directory do
    System.cmd("rm", ["-rf", @test_app_path])
  end


  defp sample_open_list_mix_exs_file do
    File.read!("../mix.exs")
  end


  defp expected_open_list_mix_exs_file do
    """
    defmodule Depz.Mixfile do
      use Mix.Project

      def project do
        [app: :depz,
         version: "0.1.0",
         elixir: "~> 1.4",
         build_embedded: Mix.env == :prod,
         start_permanent: Mix.env == :prod,
         deps: deps()]
      end

      def application do
        [extra_applications: [:logger]]
      end

      defp deps do
        [
          {:poison, "~> 3.1.0"},
          {:httpotion, "~> 3.0.2"},
        ]
      end
    end
    """
  end


  defp expected_empty_list_mix_exs_file do
    """
    defmodule Depz.Mixfile do
      use Mix.Project

      def project do
        [app: :depz,
         version: "0.1.0",
         elixir: "~> 1.4",
         build_embedded: Mix.env == :prod,
         start_permanent: Mix.env == :prod,
         deps: deps()]
      end

      def application do
        [extra_applications: [:logger]]
      end

      defp deps do
        [
          {:httpotion, "~> 3.0.2"},
        ]
      end
    end
    """
  end
end
