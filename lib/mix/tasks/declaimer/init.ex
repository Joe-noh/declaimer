defmodule Mix.Tasks.Declaimer.Init do
  @shortdoc "initialize presentation"

  def run(_) do
    unless File.exists?("img"), do: File.mkdir! "img"

    if File.exists?("lib"),  do: File.rm_rf! "lib"
    if File.exists?("test"), do: File.rm_rf! "test"

    sample_file = "presentation.exs"
    unless File.exists?(sample_file) do
      create_sample_presentation sample_file
    end
  end

  defp create_sample_presentation(filename) do
    File.write!(filename, sample_content)
  end

  defp sample_content do
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
end
