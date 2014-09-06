defmodule SampleProject.Mixfile do
  use Mix.Project

  def project do
    [app: :sample_project,
     version: "0.0.1",
     elixir: ">= 0.15.0",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:declaimer, path: "PROJECT_PATH"}]
  end
end
