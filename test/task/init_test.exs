defmodule InitTest do
  use ExUnit.Case
  alias Declaimer.Asset

  setup_all do
    tmp_dir = TestHelper.prepare_test_project
    TestHelper.run(:init, tmp_dir)

    on_exit fn -> (File.rm_rf! tmp_dir) end
  end

  test "directory structure" do
    ["mix.exs", "presentation.exs", "config", "img",
     "js/presentation.js", "css/base.css", "css/reset.css",
     "config/config.exs"]
    |> Enum.each(& assert(File.exists? &1))

    ["lib", "test"]
    |> Enum.each(& refute(File.exists? &1))
  end

  test "content of example presentation" do
    content = File.read!("presentation.exs")

    assert content =~ ~r/use Declaimer/
    assert content =~ ~r/presentation do/
  end

  test "content of config.exs" do
    content = File.read!("config/config.exs")

    assert content == Asset.config_exs
  end

  test "content of presentation.js" do
    content = File.read!("js/presentation.js")

    assert content == Asset.presentation_js
  end

  test "content of base.css" do
    content = File.read!("css/base.css")

    assert content == Asset.base_css
  end

  test "content of reset.css" do
    content = File.read!("css/reset.css")

    assert content == Asset.reset_css
  end
end
