defmodule AssetTest do
  alias Declaimer.Asset
  use ExUnit.Case

  test "sample_presentation_exs" do
    exs = Asset.sample_presentation_exs

    assert exs =~ ~r/use Declaimer/
    assert exs =~ ~r/presentation do/
  end

  test "presentation_js" do
    assert Asset.presentation_js =~ "$(function () {"
  end

  test "content of base.css" do
    assert Asset.base_css =~ ".slide.active {"
  end

  test "content of normalize.css" do
    assert Asset.reset_css =~ "html,body,div,span,"
  end
end
