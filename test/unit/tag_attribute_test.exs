defmodule TagAttributeTest do
  import Declaimer.TagAttribute

  use ExUnit.Case

  test "add_class" do
    assert add_class([a: 1], nil) == [a: 1]

    attrs = add_class([a: 1], :foo)
    assert {:a, 1} in attrs
    assert {:class, ["foo"]} in attrs

    [class: classes] = add_class([class: ["foo"]], "bar")
    assert "foo" in classes
    assert "bar" in classes
  end

  test "put_new_theme" do
    assert put_new_theme([a: 1], nil) == [a: 1]

    attrs = put_new_theme([a: 1], :foo)
    assert {:a, 1} in attrs
    assert {:theme, "foo"} in attrs

    assert put_new_theme([theme: "foo"], :bar) == [theme: "foo"]
  end
end
