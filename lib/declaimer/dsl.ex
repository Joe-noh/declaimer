defmodule Declaimer.DSL do
  alias Declaimer.Presentation

  defmacro presentation(do: {:__block__, _, contents}) do
    quote do: do_presentation(unquote contents)
  end
  defmacro presentation(do: contents) do
    quote do: do_presentation(unquote contents)
  end
  defmacro presentation(contents) do
    quote do: do_presentation(unquote contents)
  end

	defmacro do_presentation(contents) do
		{slides, metadata} = Enum.partition(contents, &elem(&1, 0) == :slide)

		quote do
			%Presentation{unquote_splicing(metadata), slides: unquote(slides)}
		end
	end

  defmacro title(title) do
		quote do: {:title, unquote title}
	end

  defmacro subtitle(sub) do
		quote do: {:subtitle, unquote sub}
	end

  defmacro date(date) do
    quote do: {:date, unquote date}
	end

  defmacro author(author) do
		quote do: {:author, unquote author}
	end

	defmacro slide(title \\ "", contents)
	defmacro slide(title, do: {:__block__, _, contents}) do
		quote do: do_slide(unquote(title), unquote(contents))
	end
	defmacro slide(title, do: contents) do
		quote do: do_slide(unquote(title), [unquote contents])
	end

	defmacro do_slide(title, contents) do
		contents = Enum.map contents, fn (content) ->
			if is_binary(content), do: {:text, content}, else: content
    end

		quote do
			{:slide, unquote(title), unquote(contents)}
		end
	end

  @tags_with_no_arg [:cite, :item]
  Enum.each @tags_with_no_arg, fn (tag) ->
    defmacro unquote(tag)(do: {:__block__, _, blocks}) do
      tag = unquote(tag)
      quote do: {unquote(tag), unquote(blocks)}
    end

    defmacro unquote(tag)(do: line) do
      tag = unquote(tag)
      quote do: {unquote(tag), [unquote line]}
    end

    defmacro unquote(tag)(line) do
      tag = unquote(tag)
      quote do: {unquote(tag), [unquote line]}
    end
  end

  @tags_with_one_arg [:code]
  Enum.each @tags_with_one_arg, fn (tag) ->
    defmacro unquote(tag)(arg, do: {:__block__, _, blocks}) do
      tag = unquote(tag)
      quote do: {unquote(tag), unquote(arg), unquote(blocks)}
    end

    defmacro unquote(tag)(arg, do: line) do
      tag = unquote(tag)
      quote do: {unquote(tag), unquote(arg), [unquote line]}
    end

    defmacro unquote(tag)(arg, line) do
      tag = unquote(tag)
      quote do: {unquote(tag), unquote(arg), [unquote line]}
    end
  end

  @list_styles [:bullet, :numbered, "bullet", "numbered"]
  Enum.each @list_styles, fn (style) ->
    style_atom = if is_atom(style) do
      style
    else
      String.to_atom style
    end

    defmacro list(unquote(style), do: {:__block__, _, blocks}) do
      style_atom = unquote(style_atom)
      quote do: {unquote(style_atom), unquote(blocks)}
    end

    defmacro list(unquote(style), do: line) do
      style_atom = unquote(style_atom)
      quote do: {unquote(style_atom), [unquote line]}
    end
  end

	defmacro table(opts \\ [], rows)
	defmacro table(opts, do: {:__block__, _, rows}) do
		do_table(opts, rows)
	end
	defmacro table(opts, do: rows) do
		do_table(opts, rows)
	end
	defmacro table(opts, rows) do
		do_table(opts, rows)
	end

	def do_table(opts, [first | rest] = rows) do
		if Keyword.get(opts, :headers, true) do
			{:table, [table_header(first) | table_rows(rest)]}
		else
			{:table, table_rows(rows)}
		end
	end

  defp table_header(headers), do: {:header, headers}
  defp table_rows(rows), do: Enum.map(rows, &{:row, &1})

	defmacro image(path) do
		{:image, [path: path]}
	end
end
