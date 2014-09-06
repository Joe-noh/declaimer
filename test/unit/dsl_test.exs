defmodule DSLTest do
  use ExUnit.Case

  use Declaimer

  test "title" do
    assert title("Title") == {:h1, ["Title"], class: ["title"]}
  end

  test "subtitle" do
    assert subtitle("Subtitle") == {:div, ["Subtitle"], class: ["subtitle"]}
  end

  test "date" do
    assert date("2014/09/02") == {:div, ["2014/09/02"], class: ["date"]}
  end

  test "author" do
    assert author("John doe") == {:div, ["John doe"], class: ["author"]}
  end

  test "cite single" do
    assert cite("Lorem ipsum") == {:blockquote, ["Lorem ipsum"], []}
  end

  test "cite multi" do
    multi  = cite do
      "Lorem"
      "ipsum"
    end

    assert multi  == {:blockquote, ["Lorem", "ipsum"], []}
  end

  test "code single" do
    code = code("elixir", "iex> 1+2")

    assert code == {:pre, [{:code, ["iex> 1+2"], class: ["elixir"]}], []}
  end

  test "code multi" do
    multi = code "elixir" do
      "iex> 1+2"
      "3"
    end

    assert multi  == {:pre, [{:code, ["iex> 1+2", "3"], class: ["elixir"]}], []}
  end

  test "list" do
    bullet = list :bullet do
      item "one"
      item "two"
    end
    numbered = list :numbered do
      item "one"
      item "two"
    end

    assert bullet   == {:ul, [{:li, ["one"], []}, {:li, ["two"], []}], []}
    assert numbered == {:ol, [{:li, ["one"], []}, {:li, ["two"], []}], []}
  end

  test "list item" do
    single = item "one"
    multi  = item do
      "one"
      "two"
    end

    assert single == {:li, ["one"], []}
    assert multi  == {:li, ["one", "two"], []}
  end

  test "table with headers" do
    table = table do
      ["one", "two"]
      [  100,   200]
      [  300,   400]
    end

    assert table == {:table, [
      {:tr, [{:th, ["one"], []}, {:th, ["two"], []}], []},
      {:tr, [{:td,   [100], []}, {:td,   [200], []}], []},
      {:tr, [{:td,   [300], []}, {:td,   [400], []}], []}
    ], []}
  end

  test "table without headers" do
    table = table header: false do
      ["one", "two"]
      [  100,   200]
      [  300,   400]
    end

    assert table == {:table, [
      {:tr, [{:td, ["one"], []}, {:td, ["two"], []}], []},
      {:tr, [{:td,   [100], []}, {:td,   [200], []}], []},
      {:tr, [{:td,   [300], []}, {:td,   [400], []}], []}
    ], []}
  end

  test "image" do
    image = image("img/photo.png")
    assert image == {:img, [], src: "img/photo.png"}
  end

  test "image with size" do
    image = image("img/photo.png", size: :full)
    assert image == {:img, [], src: "img/photo.png", class: ["full"]}
  end

  test "slide" do
    {:div, contents, attrs} =
      slide "The Slide", theme: "dark" do
        text "Lorem ipsum"
        code "elixir" do
          "iex> 1+2"
        end
      end

    expected_contents = [
        {:h2, ["The Slide"], []},
        {:p, ["Lorem ipsum"], []},
        {:pre, [
            {:code, ["iex> 1+2"], class: ["elixir"]}
        ], []}
      ]

    assert contents == expected_contents
    assert attrs[:theme] == "dark"
    assert "slide" in attrs[:class]
    refute "dark"  in attrs[:class]
  end

  test "presentation" do
    p = presentation theme: "plain" do
      title "Title"
      subtitle "Subtitle"
      author "me"

      slide "Intro" do
        cite "Lorem ipsum"
        code "elixir" do
          "iex> 1+2"
          "3"
        end
      end

      slide "List", theme: :dark do
        list :bullet do
          item "one"
          item "two"
        end
      end

      slide "Table" do
        table do
          ["a", "b"]
          [111, 222]
        end
      end
    end

    expected = """
    <div class="cover">
    <h1 class="title">Title</h1>.*
    <div class="subtitle">Subtitle</div>.*
    <div class="author">me</div>.*
    </div>.*
    <div class="(slide plain|plain slide)">.*
    <h2>Intro</h2>.*
    <blockquote>Lorem ipsum</blockquote>.*
    <pre><code class="elixir">iex> 1\\+2.*
    3</code></pre>.*
    </div>.*
    <div class="(slide dark|dark slide)">.*
    <h2>List</h2>.*
    <ul>.*
    <li>one</li>.*
    <li>two</li>.*
    </ul>.*
    </div>.*
    <div class="(slide plain|plain slide)">.*
    <h2>Table</h2>.*
    <table>.*
    <tr>.*
    <th>a</th>.*
    <th>b</th>.*
    </tr>.*
    <tr>.*
    <td>111</td>.*
    <td>222</td>.*
    </tr>.*
    </table>.*
    </div>.*
    """
    |> String.replace("\n", "")
    |> Regex.compile!("sm")

    assert p =~ expected
  end
end
