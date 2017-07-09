defmodule Depz.VersionTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  alias Depz.Version

  describe "get_version/2" do

    test "should return the latest version when version not specified" do
      assert capture_io(fn ->
        assert Version.get_version("httpotion") == {:ok, "3.0.2"}
      end) == """
      Fetching latest version of httpotion...
      Latest version is 3.0.2!
      """
    end


    test "should return the user specified version if specified" do
      assert capture_io(fn ->
        assert Version.get_version("httpotion", ["-v", "1.2.4"]) == {:ok, "1.2.4"}
      end) == ""
    end
  end
end
