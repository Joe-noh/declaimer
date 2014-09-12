defmodule Mix.Tasks.Declaimer.Compile do
  def run(_) do
    {{html, themes, opts}, _} = Code.eval_file(source_exs)

    # generate css !!
    # this does not remove existing css because the user may edit them
    Enum.each themes, fn (theme) ->
      css_file = "css/#{theme}.css"
      unless File.exists?(css_file) do
        css = ("Elixir.Declaimer.Theme.#{String.capitalize theme}"
               |> String.to_atom
               |> :erlang.make_fun(:css, 0)).()
        File.write!(css_file, css)
      end
    end

    # generate html !!
    html_file = output_html
    if File.exists?(html_file), do: File.rm!(html_file)

    File.write!(
      html_file,
      EEx.eval_string(
        template_eex,
        body: html,
        themes: themes,
        highlight_theme: highlight_js_theme(opts)
      )
    )
  end

  defp template_eex do
    """
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8">
        <link type="text/css" rel="stylesheet" href="css/reset.css">
        <link type="text/css" rel="stylesheet" href="css/base.css">
        <%= Enum.map themes, fn (theme) -> %>
          <link type="text/css" rel="stylesheet" href="css/<%= theme %>.css">
        <% end %>
        <link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/styles/<%= highlight_theme %>.min.css">
      </head>
      <body>
        <%= body %>

        <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
        <script type="text/javascript" src="js/presentation.js"></script>

        <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/highlight.min.js"></script>
        <script type="text/javascript">hljs.initHighlightingOnLoad();</script>
      </body>
    </html>
    """
  end

  defp source_exs do
    Application.get_env(:declaimer, :source_exs, "presentation.exs")
  end

  defp output_html do
    Application.get_env(:declaimer, :output_html, "presentation.html")
  end

  defp highlight_js_theme(opts) do
    theme = Application.get_env(:declaimer, :highlight_js_theme, "hybrid")
    Keyword.get(opts, :highlight_js_theme, theme)
  end
end
