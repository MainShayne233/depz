defmodule Depz.ParserTest do
  use ExUnit.Case, async: true
  alias Depz.Parser

  describe "parse_case/1" do
    test "should identify the [] case" do
      {:ok, deps_case} =
        empty_list_case_file()
        |> Parser.parse_case

      assert deps_case == :empty_list
    end

    test "should identify the collapsed_list case" do
      {:ok, deps_case} =
        collapsed_list_case_file()
        |> Parser.parse_case

      assert deps_case == :collapsed_list
    end
  end

  defp empty_list_case_file do
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
          []
        end
      end
    """
  end

  defp collapsed_list_case_file do
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
          [{:dep1, "~> 1.2"},
           {:dep2, "~> 1.4"},
           {:dep3, "~> 1.5"}]
        end
      end
    """
  end
end
