defmodule Declaimer.Builder do
  def build(triples), do: build(triples, [], [])

  def build([triple | rest], themes, acc) do
    html = do_build(triple)
    build(rest, themes, [html | acc])
  end

  def build([], themes, acc) do
    html = acc |> Enum.reverse |> Enum.join("\n")
    {html, themes}
  end

  defp do_build({tag, contents, attrs}) when is_list(contents) do
    contents = Enum.map(contents, &do_build/1) |> Enum.join("\n")
    htmlize(tag, contents, attrs)
  end
  defp do_build({tag, [], attrs}) do
    htmlize(tag, "", attrs)
  end
  defp do_build(contents) do
    contents
  end

  defp htmlize(tag, contents, []) do
    "<#{tag}>#{contents}</#{tag}>"
  end
  defp htmlize(tag, contents, attrs) do
    "<#{tag} #{stringify_attributes(attrs)}>#{contents}</#{tag}>"
  end

  defp stringify_attributes(attrs) when is_list(attrs) do
    Enum.map(attrs, &stringify_attributes/1) |> Enum.join(" ")
  end
  defp stringify_attributes({key, val}) when is_list(val) do
    ~s(#{key}="#{Enum.join(val, " ")}")
  end
  defp stringify_attributes({key, val}) when is_binary(val) do
    ~s(#{key}="#{val}")
  end
end
