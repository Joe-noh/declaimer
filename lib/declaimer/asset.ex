defmodule Declaimer.Asset do
  def sample_presentation_exs do
    """
    use Declaimer

    presentation do
      title    "Presentation"
      subtitle "with Declaimer"
      author   "John Doe"
      date     "1970-01-01"

      slide "Page 1" do
        "Hello World"
        list :bullet do
          item "こんにちわ"
          item "世界"
        end
      end

      slide "Page 2" do
        code "elixir" do
          "iex> 1+2"
          "3"
        end
      end
    end
    """
  end

  def presentation_js do
    """
    $(function () {

    })
    """
  end

  def base_css do
    """
    div.slide.active {
      visibility: visible;
    }

    div.slide.inactive {
      visibility: hidden;
      display: none;
    }
    """
  end
end

