defmodule Declaimer.TagAttribute do

  import Kernel, except: [to_string: 1]

  def apply(attrs, opts) do
    attrs
    |> add_class(opts[:deco])
    |> put_new_theme(opts[:theme])
    |> add_class(opts[:size])
  end

  def add_class(attrs, nil) do
    attrs
  end
  def add_class(attrs, [head | rest]) do
    attrs = add_class(attrs, head)
    add_class(attrs, rest)
  end
  def add_class(attrs, class) do
    class = "#{class}"
    Keyword.update(attrs, :class, [class], &[class | &1])
  end

  def put_new_theme(attrs, nil) do
    attrs
  end
  def put_new_theme(attrs, theme) do
    Keyword.put_new(attrs, :theme, "#{theme}")
  end

  def to_string({_, nil}) do
    ""
  end
  def to_string(attrs) when is_list(attrs) do
    Enum.map(attrs, &to_string/1) |> Enum.join(" ")
  end
  def to_string({key, val}) when is_list(val) do
    values = val |> Enum.filter(&(not is_nil(&1))) |> Enum.join(" ")
    ~s(#{key}="#{values}")
  end
  def to_string({key, val}) do
    ~s(#{key}="#{val}")
  end
end
