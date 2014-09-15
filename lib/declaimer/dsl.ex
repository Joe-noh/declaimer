defmodule Declaimer.DSL do
  alias Declaimer.TagAttribute
  import Declaimer.Builder

  # metadata functions !!
  def title(title),       do: {:h1,  [title],    class: ["title"]}
  def subtitle(subtitle), do: {:div, [subtitle], class: ["subtitle"]}
  def date(date),         do: {:div, [date],     class: ["date"]}
  def author(author),     do: {:div, [author],   class: ["author"]}

  # macro generation !!
  @tags_with_no_arg [:cite, :item, :text, :table, :left, :right]
  Enum.each @tags_with_no_arg, fn (tag) ->
    do_function_name = String.to_atom("do_" <> Atom.to_string(tag))

    defmacro unquote(tag)(opts \\ [], content)

    defmacro unquote(tag)(opts, do: {:__block__, _, contents}) do
      fun = unquote(do_function_name)
      quote do: unquote(fun)(unquote(opts), unquote(contents))
    end

    defmacro unquote(tag)(opts, do: content) do
      fun = unquote(do_function_name)
      quote do: unquote(fun)(unquote(opts), [unquote content])
    end

    defmacro unquote(tag)(opts, content) do
      fun = unquote(do_function_name)
      quote do: unquote(fun)(unquote(opts), [unquote content])
    end
  end

  @tags_with_one_arg [:slide, :code, :list, :link]
  Enum.each @tags_with_one_arg, fn (tag) ->
    do_function_name = String.to_atom("do_" <> Atom.to_string(tag))

    defmacro unquote(tag)(arg, opts \\ [], content)

    defmacro unquote(tag)(arg, opts, do: {:__block__, _, contents}) do
      fun = unquote(do_function_name)
      quote do: unquote(fun)(unquote(arg), unquote(opts), unquote(contents))
    end

    defmacro unquote(tag)(arg, opts, do: content) do
      fun = unquote(do_function_name)
      quote do: unquote(fun)(unquote(arg), unquote(opts), [unquote content])
    end

    defmacro unquote(tag)(arg, opts, content) do
      fun = unquote(do_function_name)
      quote do: unquote(fun)(unquote(arg), unquote(opts), [unquote content])
    end
  end

  # exceptional !!
  defmacro image(src, opts \\ []) do
    attrs = TagAttribute.apply([src: src], opts)
    quote do: {:img, [], unquote(attrs)}
  end

  defmacro takahashi(text, opts \\ []) do
    attrs = TagAttribute.add_class([], opts[:deco])
    quote do: {:div, [{:p, [unquote text], unquote(attrs)}], [class: ["takahashi"]]}
  end

  defmacro presentation(opts \\ [], do: {:__block__, _, contents}) do
    {slides, metadata} = Enum.partition(contents, &(elem(&1, 0) == :slide))

    theme = opts[:theme]
    quote do
      slides = case unquote(theme) do
        nil   -> unquote(slides)
        theme -> Enum.map unquote(slides), fn ({tag, content, attrs}) ->
                   {tag, content, TagAttribute.put_new_theme(attrs, theme)}
                 end
      end

      {html, themes} = build([{
        :div,
        unquote(metadata),
        [class: ["cover", "slide"], theme: unquote(theme)]
      } | slides])
      {html, themes, unquote(opts)}
    end
	end

  # worker functions !!
  def do_slide(title, opts, contents) do
    attrs = TagAttribute.apply([class: ["slide"]], opts)
    {:div, [{:h2, [title], []} | contents], attrs}
  end

  def do_cite(opts, contents) do
    {:blockquote, contents, TagAttribute.apply([], opts)}
  end

  def do_item(opts, contents) do
    {:li, contents, TagAttribute.apply([], opts)}
  end

  def do_text(opts, contents) do
    {:p, contents, TagAttribute.apply([], opts)}
  end

  def do_code(lang, opts, contents) do
    attrs = TagAttribute.apply([], opts)
    {:pre, [{:code, contents, class: [lang]}], attrs}
  end

  def do_list(:bullet, opts, contents) do
    {:ul, contents, TagAttribute.apply([], opts)}
  end

  def do_list(:numbered, opts, contents) do
    {:ol, contents, TagAttribute.apply([], opts)}
  end

  def do_list(invalid_type, _, _) do
    msg = "'#{invalid_type}' is invalid list type. Use :bullet or :numbered."
    raise ArgumentError, msg
  end

  def do_link(url, opts, contents) do
    {:a, contents, TagAttribute.apply([href: url], opts)}
  end

	def do_table(opts, [first | rest] = rows) do
		if Keyword.get(opts, :header, true) do
			{:table, [do_table_header(first) | do_table_rows(rest)], []}
		else
			{:table, do_table_rows(rows), []}
		end
	end

  defp do_table_header(headers) do
    {:tr, Enum.map(headers, &{:th, [&1], []}), []}
  end

  defp do_table_rows(rows) do
    Enum.map rows, fn (row) ->
      {:tr, Enum.map(row, &{:td, [&1], []}), []}
    end
  end

  def do_left(_, contents) do
    {:div, contents, class: ["left-half"]}
  end

  def do_right(_, contents) do
    {:div, contents, class: ["right-half"]}
  end
end
