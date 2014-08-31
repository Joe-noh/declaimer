defmodule BuilderBaseTest do
  use ExUnit.Case

  import Declaimer.Builder.Base
  alias Declaimer.Presentation

  test "title" do
    html = build %Presentation{title: "The Title"}
    assert html =~ "<h1>The Title</h1>"
  end

  test "subtitle" do
    html = build %Presentation{subtitle: "The Subtitle"}
    assert html =~ ~r(<div class=".*subtitle.*">The Subtitle</div>)
  end

  test "date" do
    html = build %Presentation{date: "2014-08-30"}
    assert html =~ ~r(<div class=".*date.*">2014-08-30</div>)
  end

  test "author" do
    html = build %Presentation{author: "John Doe"}
    assert html =~ ~r(<div class=".*author.*">John Doe</div>)
  end

  test "slide title" do
    html = build %Presentation{slides: [{:slide, "Slide Title", []}]}
    assert html =~ "<h2>Slide Title</h2>"
  end

  test "slide cite" do
    cite = {:cite, ["Lorem ipsum"]}
    html = build(slide cite)
    assert html =~ "<blockquote>Lorem ipsum</blockquote>"
  end

  test "slide item" do
    item = {:item, ["Hello"]}
    html = build(slide item)
    assert html =~ "<li>Hello</li>"
  end

  test "slide code" do
    code = {:code, "elixir", ["iex> 1+2"]}
    html = build(slide code)
    assert html =~ ~r(<pre><code class="elixir">iex> 1\+2</code></pre>)ms
  end

  test "slide bullet" do
    bullet = {:bullet, [{:item, ["Hello"]}]}
    html = build(slide bullet)
    assert html =~ ~r(<ul><li>Hello</li></ul>)ms
  end

  test "slide numbered" do
    numbered = {:numbered, [{:item, ["Hello"]}]}
    html = build(slide numbered)
    assert html =~ ~r(<ol><li>Hello</li></ol>)ms
  end

  test "slide table" do
    table = {:table, [{:row, [1, 2]}, {:row, ["I", "II"]}]}
    html = build(slide table)
    assert html =~ ~r(<table><tr><td>1</td><td>2</td></tr>.*I.*II.*</tr></table>)ms
  end

  test "slide img" do
    img = {:image, "~/Pictures/Sample/img.png"}
    html = build(slide img)
    assert html =~ ~s(<img src="~/Pictures/Sample/img.png">)
  end

  defp slide(content) when is_list(content) do
    %Presentation{slides: [{:slide, "", content}]}
  end

  defp slide(content) do
    %Presentation{slides: [{:slide, "", [content]}]}
  end
end
