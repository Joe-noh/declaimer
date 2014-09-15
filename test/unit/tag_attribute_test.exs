defmodule TagAttributeTest do
  import Kernel, except: [apply: 2]
  import Declaimer.TagAttribute

  use ExUnit.Case

  test "apply" do
    opts = [theme: "bar", deco: ["bold", :strike]]
    attrs = apply([class: ["foo"]], opts)

    assert attrs[:theme] == "bar"
    assert "foo"    in attrs[:class]
    assert "bold"   in attrs[:class]
    assert "strike" in attrs[:class]
  end

  test "add_class" do
    assert add_class([a: 1], nil) == [a: 1]

    attrs = add_class([a: 1], :foo)
    assert {:a, 1} in attrs
    assert {:class, ["foo"]} in attrs

    [class: classes] = add_class([class: ["foo"]], "bar")
    assert "foo" in classes
    assert "bar" in classes

    [class: classes] = add_class([class: ["foo"]], ["bar", "baz"])
    assert "foo" in classes
    assert "bar" in classes
    assert "baz" in classes
  end

  test "put_new_theme" do
    assert put_new_theme([a: 1], nil) == [a: 1]

    attrs = put_new_theme([a: 1], :foo)
    assert {:a, 1} in attrs
    assert {:theme, "foo"} in attrs

    assert put_new_theme([theme: "foo"], :bar) == [theme: "foo"]
  end
end
