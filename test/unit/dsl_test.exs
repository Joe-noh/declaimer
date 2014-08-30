defmodule DSLTest do
  use ExUnit.Case

  import Declaimer.DSL
  alias Declaimer.Presentation

  test "title" do
    assert title("The Title") == {:title, "The Title"}
  end

  test "subtitle" do
    assert subtitle("The Subtitle") == {:subtitle, "The Subtitle"}
  end

  test "date" do
    assert date("2014年8月28日") == {:date, "2014年8月28日"}
  end

  test "author" do
    assert author("Joe Honzawa") == {:author, "Joe Honzawa"}
  end

  test "cite" do
    single = cite "Lorem ipsum"
    multi  = cite do
      "Lorem"
      "ipsum"
    end

    assert single == {:cite, ["Lorem ipsum"]}
    assert multi  == {:cite, ["Lorem", "ipsum"]}
  end

  test "code" do
    single = code("elixir", "iex> 1+2")
    multi  = code "elixir" do
      "iex> 1+2"
      "3"
    end

    assert single == {:code, "elixir", ["iex> 1+2"]}
    assert multi  == {:code, "elixir", ["iex> 1+2", "3"]}
  end

  test "list" do
    bullet = list :bullet do
      item "one"
      item "two"
    end
    numbered = list "numbered" do
      item "one"
      item "two"
    end

    assert bullet   == {:bullet,   [{:item, ["one"]}, {:item, ["two"]}]}
    assert numbered == {:numbered, [{:item, ["one"]}, {:item, ["two"]}]}
  end

  test "list item" do
    single = item "one"
    multi  = item do
      "one"
      "two"
    end

    assert single == {:item, ["one"]}
    assert multi  == {:item, ["one", "two"]}
  end

  test "table with headers" do
    table = table do
      ["one", "two"]
      [  100,   200]
      [  300,   400]
    end

    assert table == {:table,
      [{:header, ["one", "two"]},
        {:row,    [  100,   200]},
        {:row,    [  300,   400]}]}
  end

  test "table without headers" do
    table = table headers: false do
      ["one", "two"]
      [  100,   200]
      [  300,   400]
    end

    assert table == {:table,
      [{:row, ["one", "two"]},
       {:row, [  100,   200]},
       {:row, [  300,   400]}]}
  end

  test "slide" do
    slide = slide "The Slide" do
      "Lorem ipsum"
      code "elixir" do
        "iex> 1+2"
        "3"
      end
    end

    assert slide == {:slide, "The Slide",
      [{:text, "Lorem ipsum"},
        {:code, "elixir", ["iex> 1+2", "3"]}]}
  end

  test "presentation" do
    p = presentation do
      title    "The Title"
      subtitle "The Subtitle"
      date     "2014-08-28"
      author   "me"

      slide "Page 1" do
        "Hello"
      end

      slide "Page 2" do
        "Thanks"
      end
    end

    assert p == %Presentation{
      title:    "The Title",
      subtitle: "The Subtitle",
      date:     "2014-08-28",
      author:   "me",
      slides: [{:slide, "Page 1", [{:text, "Hello"}]},
               {:slide, "Page 2", [{:text, "Thanks"}]}]
    }
  end
end
