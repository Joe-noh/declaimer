defmodule Mix.Tasks.Declaimer.Init do
  @shortdoc "initialize presentation"

  alias Declaimer.Asset

  def run(_) do
    ["img", "js", "css"]
    |> Enum.each(fn (dir) ->
      unless File.exists?(dir), do: File.mkdir!(dir)
    end)

    ["lib", "test"]
    |> Enum.each(fn (dir) ->
      if File.exists?(dir),  do: File.rm_rf!(dir)
    end)

    path = "presentation.exs"
    unless File.exists?(path) do
      create_sample_presentation path
    end

    path = "js/presentation.js"
    unless File.exists?(path) do
      create_presentation_js path
    end

    path = "css/base.css"
    unless File.exists?(path) do
      create_base_css path
    end

    path = "css/reset.css"
    unless File.exists?(path) do
      create_reset_css path
    end
  end

  defp create_sample_presentation(filepath) do
    File.write!(filepath, Asset.sample_presentation_exs)
  end

  defp create_presentation_js(filepath) do
    File.write!(filepath, Asset.presentation_js)
  end

  defp create_base_css(filepath) do
    File.write!(filepath, Asset.base_css)
  end

  defp create_reset_css(filepath) do
    File.write!(filepath, Asset.reset_css)
  end
end
