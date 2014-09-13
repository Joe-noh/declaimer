defmodule ConfigTest do
  alias Declaimer.Config
  use ExUnit.Case

  test "source_exs" do
    Application.delete_env(:declaimer, :source_exs)
    assert Config.source_exs == "presentation.exs"

    Application.put_env(:declaimer, :source_exs, "source.exs")
    assert Config.source_exs == "source.exs"
  end

  test "output_html" do
    Application.delete_env(:declaimer, :output_html)
    assert Config.output_html == "presentation.html"

    Application.put_env(:declaimer, :output_html, "output.html")
    assert Config.output_html == "output.html"
  end

  test "highlight_js_theme" do
    Application.delete_env(:declaimer, :highlight_js_theme)
    assert Config.highlight_js_theme == "hybrid"

    Application.put_env(:declaimer, :highlight_js_theme, "github")
    assert Config.highlight_js_theme == "github"
  end

  test "highlight_js_path" do
    Application.delete_env(:declaimer, :highlight_js_path)
    assert Config.highlight_js_path ==
      "http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/highlight.min.js"

    Application.put_env(:declaimer, :highlight_js_path, "js/hljs.min.js")
    assert Config.highlight_js_path == "js/hljs.min.js"
  end
end

