defmodule Depz.VersionTest do
  use ExUnit.Case, async: true
  alias Depz.Version

  describe "get_version/2" do

    test "should return the latest version when version not specified" do
      assert Version.get_version(:httpotion) == {:ok, "3.0.2"}
    end


    test "should return the user specified version if specified" do
      assert Version.get_version(:httpotion, ["-v", "1.2.4"]) == {:ok, "1.2.4"}
    end
  end
end
