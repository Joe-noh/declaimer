## Declaimer

A tool for making presentation slides.

### Getting Started

```console
$ mix new great_talk
$ cd ./great_talk
$ ls -l
total 32
8 -rw-r--r--  1 joe  staff  1078  9 19 19:21 LICENSE
8 -rw-r--r--  1 joe  staff  3692  9 27 01:18 README.md
0 drwxr-xr-x  3 joe  staff   102  9 19 19:21 config
0 drwxr-xr-x  5 joe  staff   170  9 19 19:21 lib
8 -rw-r--r--  1 joe  staff   251  9 19 19:21 mix.exs
8 -rw-r--r--  1 joe  staff    38  9 19 19:21 mix.lock
0 drwxr-xr-x  6 joe  staff   204  9 19 19:21 test
```

Add `declaimer` to deps in `mix.exs`.

```elixir
def deps do
  [{:declaimer, github: "Joe-noh/declaimer"}]
end
```

Then do this.

```
$ mix do deps.get, deps.compile
```

Now you can use a few declaimer tasks. At first, you have to initialize your project directory.

```
$ mix declaimer.init
```

You'll see some new files and directories. It's time to compile!

```
$ mix declaimer.compile
```

`compile` task generates `presentation.html` from `presentation.exs`. Opening this file in your browser, you can go back and forth with cursor keys.

### Syntax

#### Outline

```elixir
use Declaimer

presentation do
  title    "Great Talk"
  subtitle "You must be impressed"
  author   "John Doe"
  date     "2014 Sep. 24th"

  slide "Introduction" do
    text "bla bla"
  end
end
```

As you know `presentation.exs` is an elixir script. `declaimer.compile` task evaluates this file to make HTML, so valid elixir code should be there.

First, `use Declaimer` is required. This make us to be able to use Declaimer DSL. The body of presentation has to be surrounded by `presentation do ... end`.

#### Metadata

There are four type of metadata. They will be rendered on the cover page.

- `title`
- `subtitle`
- `author`
- `date`

All of them take one argument which type is `binary`.

#### Slide

`slide` DSL accept one `binary` and one `do block`. This represents a page of presentation. Also optional setting can be given like this.

```
slide "Introduction", theme: :dark do
  text "bla bla"
end
```

Now valid option is only `:theme`, and there is only one theme `:dark` (pull requests are welcomed).

#### Slide Contents

##### plain text

```elixir
text "foo bar"
```

##### citation

```elixir
cite do
  # arbitary content
end
```

##### source code

```elixir
code "html" do
  """
  !doctype html
  <html>
    <body></body>
  </html>
  """
end
```

`code` takes a name of the language which is put inside the block.
It will be directly used as HTML class of `<code>` tag. You can see valid name [here](http://highlightjs.readthedocs.org/en/latest/css-classes-reference.html).

##### list

```elixir
bullet do
  item "one"
  item "two"
end

numbered do
  item "one"
  item "two"
end
```

There are two types of list, `bullet` and `numbered`. `item` has an alias `o` therefore you can write like this.

```elixir
bullet do
  o "one"
  o "two"
end
```

##### image

```elixir
image "path/to/image"
```

##### link

```elixir
link "path/to/where/you/go" do
  # arbitary content
end
```

##### table

```elixir
table do
  ["a", "b", "c"]  # enclosed with <th>
  [100, 200, 300]  # enclosed with <td>
end

table header: false do
  ["a", "b", "c"]  # enclosed with <td>
  [100, 200, 300]  # enclosed with <td>
end
```

##### decorations

You can make texts on your slides bold, italic and so on with `deco` option.
Type of the value is `binary` or `atom`.

```elixir
text "this will be bold", deco: "bold"
text "will be italic",    deco: "italic"
text "strike-through",    deco: "strike"
text "underlined text",   deco: :underline
text "monospace font",    deco: :monospace
```

Notations like following are valid.

```elixir
numbered do
  o "Yeah !!", deco: [:bold, :underline]
end
```

Note: you can't apply these decorations only a part of a line.

##### layout

A slide can be divided with `left` and `right`.

```elixir
slide "L and R" do
  left do
    # content placed in left-half of this slide
  end

  right do
    # content placed in right-half
  end
end
```

### Contribution

Any kind of contribution is welcomed.

- requests
- ideas
- reports
- complaints
