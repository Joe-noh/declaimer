defmodule PresentationTest do
  use ExUnit.Case
  alias Declaimer.Presentation

  test "struct" do
    presentation = %Presentation{}

    assert presentation.title    == ""
    assert presentation.subtitle == ""
    assert presentation.author   == ""
    assert presentation.date     == ""
    assert presentation.slides   == []
  end
end

