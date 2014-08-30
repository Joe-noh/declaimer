defmodule InitTest do
  use ExUnit.Case

  setup_all do
    project_path = (__DIR__ |> Path.dirname |> Path.dirname)

    tmp_dir = Path.join(System.tmp_dir!, "for_declaimer_test")
    File.cp_r!("test/sample_project", tmp_dir)
    File.cd! tmp_dir

    replace_exp = "s/PROJECT_PATH/" <> String.replace(project_path, "\/", "\\/") <> "/"
    System.cmd("sed", ["-i", replace_exp, "mix.exs"])

    System.cmd("mix", ["declaimer.init"])

    on_exit fn ->
      File.rm_rf! tmp_dir
    end
  end

  test "directory structure" do
    Enum.each ["mix.exs", "presentation.exs", "config", "img"], fn (file) ->
      assert File.exists?(file)
    end

    Enum.each ["lib", "test"], fn (file) ->
      refute File.exists?(file)
    end
  end

  test "content of example presentation" do
    content = File.read!("presentation.exs")

    assert content =~ ~r/use Declaimer/
    assert content =~ ~r/presentation do/
  end
end
