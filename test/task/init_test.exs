defmodule InitTest do
  use ExUnit.Case

  setup_all do
    tmp_dir = TestHelper.prepare_test_project
    TestHelper.run(:init, tmp_dir)

    on_exit fn -> (File.rm_rf! tmp_dir) end
  end

  test "directory structure" do
    ["mix.exs", "presentation.exs", "config", "img",
     "js/presentation.js", "css/base.css", "css/normalize.css"]
    |> Enum.each(& assert(File.exists? &1))

    ["lib", "test"]
    |> Enum.each(& refute(File.exists? &1))
  end

  test "content of example presentation" do
    content = File.read!("presentation.exs")

    assert content =~ ~r/use Declaimer/
    assert content =~ ~r/presentation do/
  end

  test "content of presentation.js" do
    content = File.read!("js/presentation.js")

    assert content =~ "$(function () {"
  end

  test "content of base.css" do
    content = File.read!("css/base.css")

    assert content =~ "div.slide.active {"
  end

  test "content of normalize.css" do
    content = File.read!("css/normalize.css")

    assert content =~ "normalize.css v3.0.1"
  end
end
