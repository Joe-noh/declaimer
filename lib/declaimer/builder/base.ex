defmodule Declaimer.Builder.Base do
  alias Declaimer.Presentation

  def build(%Presentation{} = presentation) do
    cover = """
    <h1>#{presentation.title}</h1>
    <div class="subtitle">#{presentation.subtitle}</div>
    <div class="date">#{presentation.date}</div>
    <div class="author">#{presentation.author}</div>
    """
    slides = Enum.map_join(presentation.slides, &(build_slide &1))

    """
    <html>
    #{head_template("")}
    #{body_template(cover <> slides)}
    </html>
    """
  end

  defp build_slide({:slide, title, content}) do
    """
    <div class="slide">
    <h2>#{title}</h2>
    #{build_slide content}
    </div>
    """
    |> String.strip
  end

  defp build_slide([{:cite, content} | rest]) do
    """
    <blockquote>#{build_slide content}</blockquote>
    #{build_slide rest}
    """
    |> String.strip
  end

  defp build_slide([{:item, content} | rest]) do
    """
    <li>#{build_slide content}</li>
    #{build_slide rest}
    """
    |> String.strip
  end

  defp build_slide([{:code, language, content} | rest]) do
    """
    <pre><code class="#{language}">#{content}</code></pre>
    #{build_slide rest}
    """
    |> String.strip
  end

  defp build_slide([{:bullet, content} | rest]) do
    """
    <ul>#{build_slide content}</ul>
    #{build_slide rest}
    """
    |> String.strip
  end

  defp build_slide([{:numbered, content} | rest]) do
    """
    <ol>#{build_slide content}</ol>
    #{build_slide rest}
    """
    |> String.strip
  end

  defp build_slide([{:table, content} | rest]) do
    """
    <table>#{build_slide content}</table>
    #{build_slide rest}
    """
    |> String.strip
  end

  defp build_slide([{:header, content} | rest]) do
    headers = Enum.map_join(content, &("<th>#{&1}</th>"))
    """
    <tr>#{headers}</tr>
    #{build_slide rest}
    """
    |> String.strip
  end

  defp build_slide([{:row, content} | rest]) do
    rows = Enum.map_join(content, &("<td>#{&1}</td>"))
    """
    <tr>#{rows}</tr>
    #{build_slide rest}
    """
    |> String.strip
  end

  defp build_slide([{:image, path} | rest]) do
    """
    <img src="#{path}">
    #{build_slide rest}
    """
    |> String.strip
  end

  defp build_slide([content | rest]) when is_binary(content) do
    content <> (build_slide rest)
  end

  defp build_slide([]), do: ""

  defp head_template(content) do
    """
    <head>
      #{content}
    </head>
    """
  end

  defp body_template(content) do
    """
    <body>
      #{content}
    </body>
    """
  end
end
