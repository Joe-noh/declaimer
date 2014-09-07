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

    sample_file = "presentation.exs"
    unless File.exists?(sample_file) do
      create_sample_presentation sample_file
    end

    js_file = "js/presentation.js"
    unless File.exists?(js_file) do
      create_presentation_js js_file
    end

    css_file = "css/base.css"
    unless File.exists?(css_file) do
      create_base_css css_file
    end

    norm = "css/normalize.css"
    unless File.exists?(norm) do
      create_normalize_css norm
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

  defp create_normalize_css(filepath) do
    File.write!(filepath, Asset.normalize_css)
  end
end
