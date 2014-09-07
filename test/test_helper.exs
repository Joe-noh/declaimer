ExUnit.start

defmodule TestHelper do

  @project_path Path.dirname(__DIR__)

  def prepare_test_project do
    random_id = :random.uniform(1000000) |> Integer.to_string

    tmp_dir = Path.join(System.tmp_dir!, "for_declaimer_test_" <> random_id)
    File.cp_r!(@project_path <> "/test/sample_project", tmp_dir)

    File.cd! tmp_dir
    replace_exp = "s/PROJECT_PATH/" <> String.replace(@project_path, "\/", "\\/") <> "/"
    System.cmd("sed", ["-i", replace_exp, "mix.exs"])

    tmp_dir
  end

  def run(:init, tmp_dir) do
    File.cd! tmp_dir
    System.cmd("mix", ["declaimer.init"])
  end

  def run(:compile, tmp_dir) do
    File.cd! tmp_dir
    System.cmd("mix", ["declaimer.compile"])
  end

  def run(another, _) do
    raise ArgumentError, message: "No such task: #{another}"
  end
end
