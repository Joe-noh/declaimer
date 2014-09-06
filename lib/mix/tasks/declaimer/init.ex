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
  end

  defp create_sample_presentation(filename) do
    File.write!(filename, Asset.sample_presentation_exs)
  end

  defp create_presentation_js(filename) do
    File.write!(filename, Asset.presentation_js)
  end

  defp create_base_css(filename) do
    File.write!(filename, Asset.base_css)
  end
end
