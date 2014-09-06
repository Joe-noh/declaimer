defmodule Declaimer do
  defmacro __using__(_) do
    quote do
      import Declaimer.DSL
      import Declaimer.Builder
    end
  end
end
