defmodule Depz.ParserTest do
  use ExUnit.Case, async: true
  alias Depz.Parser


  describe("parse_deps/1") do
    test "should return a list of the deps" do
      {:ok, deps} =
        variety_of_deps_file()
        |> Parser.parse_deps

      assert deps == [
        {:cowboy, "~> 1.0", optional: true},
        {:plug, "~> 1.3.2 or ~> 1.4"},
        {:phoenix_pubsub, "~> 1.0"},
        {:poison, "~> 2.2 or ~> 3.0"},
        {:gettext, "~> 0.8", only: :test},
        {:ex_doc, "~> 0.16", only: :docs},
        {:inch_ex, "~> 0.2", only: :docs},
        {:phoenix_guides, git: "https://github.com/phoenixframework/phoenix_guides.git", compile: false, app: false, only: :docs},
        {:phoenix_html, "~> 2.6", only: :test},
        {:websocket_client, git: "https://github.com/jeremyong/websocket_client.git", only: :test},
      ]
    end
  end


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


    test "should identify the open_list case" do
      {:ok, deps_case} =
        open_list_case_file()
        |> Parser.parse_case

      assert deps_case == :open_list
    end
  end


  defp variety_of_deps_file do
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
            {:cowboy, "~> 1.0", optional: true},
            {:plug, "~> 1.3.2 or ~> 1.4"},
            {:phoenix_pubsub, "~> 1.0"},
            {:poison, "~> 2.2 or ~> 3.0"},
            {:gettext, "~> 0.8", only: :test},

            # Docs dependencies
            {:ex_doc, "~> 0.16", only: :docs},
            {:inch_ex, "~> 0.2", only: :docs},
            {:phoenix_guides, git: "https://github.com/phoenixframework/phoenix_guides.git", compile: false, app: false, only: :docs},
            # Test dependencies
            {:phoenix_html, "~> 2.6", only: :test},
            {:websocket_client, git: "https://github.com/jeremyong/websocket_client.git", only: :test}
          ]
        end
      end
    """
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


  defp open_list_case_file do
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
            {:dep1, "~> 1.2"},
            {:dep2, "~> 1.4"},
            {:dep3, "~> 1.5"}
          ]
        end
      end
    """
  end
end
