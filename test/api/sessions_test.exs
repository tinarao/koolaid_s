defmodule Api.SessionsTest do
  use ApiWeb.ConnCase, async: true
  alias Api.Sessions

  describe "sessions" do
    test "should save key" do
      key = "abc-def-ghi-jkl"
      Sessions.put(key)
      assert Sessions.exists?(key)
    end

    test "key should be available before it expires" do
      key = "abo-baa-bob-abo"

      Sessions.put(key, 1000)
      Process.sleep(500)
      assert Sessions.exists?(key)
    end

    test "key should live no longer than TTL" do
      key = "mno-pqr-stu-vwx"

      Sessions.put(key, 100)
      Process.sleep(150)

      refute Sessions.exists?(key)
    end
  end
end
