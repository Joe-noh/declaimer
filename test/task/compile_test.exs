defmodule CompileTest do
  use ExUnit.Case

  setup_all do
    tmp_dir = TestHelper.prepare_test_project
    TestHelper.run(:init,    tmp_dir)
    TestHelper.run(:compile, tmp_dir)

    on_exit fn -> (File.rm_rf! tmp_dir) end
  end

  test "contents of presentation.html" do
    content = File.read!("presentation.html")

    assert content =~ "<!DOCTYPE html>"
    assert content =~ "normalize.css"
    assert content =~ "base.css"
    assert content =~ "presentation.js"
    assert content =~ "<div"
  end
end
