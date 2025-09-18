defmodule Api.SessionsTest do
  use ApiWeb.ConnCase, async: true
  alias Api.Sessions

  @device_id "device_id"

  describe "sessions" do
    test "should save key" do
      key = "abc-def-ghi-jkl"
      Sessions.put(key, @device_id)
      assert Sessions.exists?(key)
    end

    test "key should be available before it expires" do
      key = "abo-baa-bob-abo"

      Sessions.put(key, @device_id, 1000)
      Process.sleep(500)
      assert Sessions.exists?(key)
    end

    test "key should live no longer than TTL" do
      key = "mno-pqr-stu-vwx"

      Sessions.put(key, @device_id, 100)
      Process.sleep(150)

      refute Sessions.exists?(key)
    end
  end
end
