defmodule Declaimer.DSL do
  alias Declaimer.TagAttribute
  import Declaimer.Builder

  # metadata functions !!
  def title(title),       do: {:h1,  [title],    class: ["title"]}
  def subtitle(subtitle), do: {:div, [subtitle], class: ["subtitle"]}
  def date(date),         do: {:div, [date],     class: ["date"]}
  def author(author),     do: {:div, [author],   class: ["author"]}

  # macro generation !!
  @tags_with_no_arg [:cite, :item, :text, :table]
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

  @tags_with_one_arg [:slide, :code, :list]
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
    attrs = TagAttribute.add_class([src: src], opts[:size])
    quote do: {:img, [], unquote(attrs)}
  end

  defmacro presentation(opts \\ [], do: {:__block__, _, contents}) do
    {slides, metadata} = Enum.partition(contents, &(elem(&1, 0) == :slide))
    default_theme = opts[:theme]
    quote do
      slides = unquote(slides)
        |> Enum.map(fn ({tag, contents, attrs}) ->
          attrs = TagAttribute.put_new_theme(attrs, unquote(default_theme))
          {tag, contents, attrs}
        end)

      {html, themes} = build(
        [{:div, unquote(metadata), class: ["cover", "slide", unquote(default_theme)]} | slides]
      )
      html
    end
	end

  # worker functions !!
  def do_slide(title, opts, contents) do
    attrs = TagAttribute.put_new_theme([class: ["slide"]], opts[:theme])

    {:div, [{:h2, [title], []} | contents], attrs}
  end

  def do_cite(_, contents) do
    {:blockquote, contents, []}
  end

  def do_item(_, contents) do
    {:li, contents, []}
  end

  def do_text(_, contents) do
    {:p, contents, []}
  end

  def do_code(lang, _, contents) do
    {:pre, [{:code, contents, class: [lang]}], []}
  end

  def do_list(:bullet, _, contents) do
    {:ul, contents, []}
  end

  def do_list(:numbered, _, contents) do
    {:ol, contents, []}
  end

  def do_list(invalid_type, _, _) do
    msg = "'#{invalid_type}' is invalid list type. Use :bullet or :numbered."
    raise ArgumentError, msg
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
end
