defmodule Declaimer.DSL do
  alias Declaimer.TagAttribute
  import Declaimer.Builder

  # metadata functions !!
  def title(title),       do: {:h1,  [title],    class: ["title"]}
  def subtitle(subtitle), do: {:div, [subtitle], class: ["subtitle"]}
  def date(date),         do: {:div, [date],     class: ["date"]}
  def author(author),     do: {:div, [author],   class: ["author"]}

  # macro generation !!

  # tags which take optional options and a do-end block
  [:cite, :table, :left, :right, :bullet, :numbered]
  |> Enum.each fn (tag) ->
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
  end

  # tags which accept one argument and optional options
  [:item, :text, :image, :takahashi]
  |> Enum.each fn (tag) ->
    do_function_name = String.to_atom("do_" <> Atom.to_string(tag))

    defmacro unquote(tag)(arg, opts \\ []) do
      fun = unquote(do_function_name)
      quote do: unquote(fun)(unquote(arg), unquote(opts))
    end
  end

  # tags which accept one argument, optional option and one block
  [:slide, :code, :link]
  |> Enum.each fn (tag) ->
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
  end

  # exceptional !!
  defmacro link(arg, opts, content) when is_binary(content) do
    quote do
      do_link(unquote(arg), unquote(opts), [text unquote content])
    end
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

  def do_item(text, opts) do
    {:li, [text], TagAttribute.apply([], opts)}
  end

  def do_text(text, opts) do
    {:p, [text], TagAttribute.apply([], opts)}
  end

  def do_image(src, opts) do
    {:img, [], TagAttribute.apply([src: src], opts)}
  end

  def do_takahashi(text, opts) do
    attrs = TagAttribute.add_class([], opts[:deco])
    {:div, [{:p, [text], attrs}], class: ["takahashi"]}
  end

  def do_code(lang, opts, contents) do
    attrs = TagAttribute.apply([], opts)
    {:pre, [{:code, contents, class: [lang]}], attrs}
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

  def do_bullet(_, contents) do
    {:ul, contents, []}
  end

  def do_numbered(_, contents) do
    {:ol, contents, []}
  end
end
