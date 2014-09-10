defmodule Declaimer.Builder do
  alias Declaimer.TagAttribute

  def build(triples), do: build(triples, [], [])

  def build([{:div, content, [{:theme, theme} | other_attrs]} | rest], themes, acc) do
    attrs = TagAttribute.add_class(other_attrs, theme)
    html  = do_build({:div, content, attrs})
    build(rest, [theme | themes], [html | acc])
  end
  def build([triple | rest], themes, acc) do
    html = do_build(triple)
    build(rest, themes, [html | acc])
  end
  def build([], themes, acc) do
    html = acc |> Enum.reverse |> Enum.join("\n")
    {html, Enum.uniq(themes)}
  end

  defp do_build({tag, [], attrs}) do
    htmlize(tag, "", attrs)
  end
  defp do_build({tag, contents, attrs}) when is_list(contents) do
    contents = Enum.map(contents, &do_build/1) |> Enum.join("\n")
    htmlize(tag, contents, attrs)
  end
  defp do_build(contents) do
    escape_html(contents)
  end

  defp htmlize(tag, contents, []) do
    "<#{tag}>#{contents}</#{tag}>"
  end
  defp htmlize(tag, contents, attrs) do
    "<#{tag} #{TagAttribute.to_string attrs}>#{contents}</#{tag}>"
  end

  defp escape_html(target) when is_binary(target) do
    target
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")  # enough?
  end

  defp escape_html(target) when is_integer(target) do
    to_string(target)
  end
end
