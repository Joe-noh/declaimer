defmodule Declaimer.Config do

  [
    {:source_exs,         "presentation.exs"},
    {:output_html,        "presentation.html"},
    {:highlight_js_theme, "hybrid"},
    {:highlight_js_path,  "http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/highlight.min.js"}
  ]
  |> Enum.each fn ({key, default_value}) ->
    def unquote(key)() do
      Application.get_env(:declaimer, unquote(key), unquote(default_value))
    end
  end
end
