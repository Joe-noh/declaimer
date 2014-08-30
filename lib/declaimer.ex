defmodule Declaimer do
  defmacro __using__(_) do
    quote do
      alias Declaimer.DSL
      import Declaimer.DSL
    end
  end
end
