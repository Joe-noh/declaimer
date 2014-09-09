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
      var currentIndex = 0,
          nextIndex    = 0,
          slides = $("div.slide");

      slides.each(function (i, e) {
        $(e).addClass(i === 0 ? "active" : "inactive");
      });

      $(document).on("keydown", function (event) {
        switch (event.keyCode) {
          case 37: // left arrow
            goToPreviousSlide();
            break;
          case 39: // right arrow
            goToSucceedingSlide();
            break;
          default:
            return;
        }

        event.preventDefault();
      });

      function goToPreviousSlide() {
        nextIndex = currentIndex ? currentIndex - 1 : currentIndex;
        switchSlide();
      }

      function goToSucceedingSlide() {
        nextIndex = currentIndex + (currentIndex < slides.length-1 ? 1 : 0);
        switchSlide();
      }

      function switchSlide() {
        deactivate(currentIndex);
        activate(nextIndex);

        currentIndex = nextIndex;
      }
      function activate(index) {
        $(slides[index]).removeClass("inactive").addClass("active");
      }

      function deactivate(index) {
        $(slides[index]).removeClass("active").addClass("inactive");
      }
    });
    """
  end

  def base_css do
    """
    body, html, div.slide {
      height: 100%;
      width:  100%;
      overflow: hidden;
    }

    @media screen {
      div.slide.active {
        visibility: visible;
      }

      div.slide.inactive {
        visibility: hidden;
        display: none;
      }
    }

    @media print {
      div.slide.active, div.slide.inactive {
        visibility: visible;
      }
    }

    .cover * {
      position: absolute;
      left: 10%;
    }

    .cover .title {
      top: 10%;
      font-size: 1000%;
    }

    .cover .subtitle {
      top: 30%;
      font-size: 700%;
    }

    .cover .author {
      top: 60%;
      font-size: 500%;
    }

    .cover .date {
      top: 80%;
      font-size: 400%;
    }

    .slide:not(.cover) * {
      position: relative;
    }

    .slide h2 {
      margin: 2% 0 2% 4%;
      font-size: 500%;
    }

    .slide p {
      margin-left: 7%;
      font-size: 400%;
    }

    .slide.takahashi {
      display: inline-table;
    }

    .slide.takahashi * {
      width: 90%;
      vertical-align: middle;
      text-align: center;
      display: table-cell;
      font-size: 1100%;
    }

    .slide > ul {
      margin-left: 7%;
      font-size: 400%;
    }

    .slide > ol {
      margin-left: 10%;
      font-size: 400%;
    }

    .slide ul ul, .slide ol ul {
      margin-left: 4%;
      font-size: 100%;
    }

    .slide ul ol, .slide ol ol {
      margin-left: 7%;
      font-size: 100%;
    }

    .slide > blockquote, .slide > pre {
      margin: 0 auto;
      width: 90%;
    }

    .slide pre {
      font-size: 300%;
    }

    .slide blockquote {
      background-color: #e8e8e8;
      font-size: 400%;
      padding: 2%;
    }

    .slide ul blockquote, .slide ol blockquote {
      width: 90%;
      font-size: inherit;
    }

    .slide table {
      margin: 0 auto;
      width: 90%;
      font-size: 400%;
    }

    .slide table, .slide td, .slide th {
      border: 1px black solid;
    }

    .slide img {
      margin: 0 auto;
      display: block;
    }

    .slide img.height-max {
      min-height: 100%;
      width: auto;
    }

    .slide img.width-max {
      height: auto;
      min-width: 100%;
    }
    """
  end

  def normalize_css do
    """
    /*! normalize.css v3.0.1 | MIT License | git.io/normalize */

    html { font-family: sans-serif; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; }
    body { margin: 0; }
    article, aside, details, figcaption, figure,
    footer, header, hgroup, main, nav, section, summary { display: block; }
    audio, canvas, progress, video { display: inline-block; vertical-align: baseline; }
    audio:not([controls]) { display: none; height: 0; }
    [hidden], template { display: none; }
    a { background: transparent; }
    a:active, a:hover { outline: 0; }
    abbr[title] { border-bottom: 1px dotted; }
    b, strong { font-weight: bold; }
    dfn { font-style: italic; }
    h1 { font-size: 2em; margin: 0.67em 0; }
    mark { background: #ff0; color: #000; }
    small { font-size: 80%; }
    sub, sup { font-size: 75%; line-height: 0; position: relative; vertical-align: baseline; }
    sup { top: -0.5em; }
    sub { bottom: -0.25em; }
    img { border: 0; }
    svg:not(:root) { overflow: hidden; }
    figure { margin: 1em 40px; }
    hr { -moz-box-sizing: content-box; box-sizing: content-box; height: 0; }
    pre { overflow: auto; }
    code, kbd, pre, samp { font-family: monospace, monospace; font-size: 1em; }
    button, input, optgroup, select, textarea { color: inherit; font: inherit; margin: 0; }
    button { overflow: visible; }
    button, select { text-transform: none; }
    button, html input[type="button"], input[type="reset"], input[type="submit"] { -webkit-appearance: button; cursor: pointer; }
    button[disabled], html input[disabled] { cursor: default; }
    button::-moz-focus-inner, input::-moz-focus-inner { border: 0; padding: 0; }
    input { line-height: normal; }
    input[type="checkbox"], input[type="radio"] { box-sizing: border-box; padding: 0; }
    input[type="number"]::-webkit-inner-spin-button, input[type="number"]::-webkit-outer-spin-button { height: auto; }
    input[type="search"] { -webkit-appearance: textfield; -moz-box-sizing: content-box; -webkit-box-sizing: content-box; box-sizing: content-box; }
    input[type="search"]::-webkit-search-cancel-button, input[type="search"]::-webkit-search-decoration { -webkit-appearance: none; }
    fieldset { border: 1px solid #c0c0c0; margin: 0 2px; padding: 0.35em 0.625em 0.75em; }
    legend { border: 0; padding: 0; }
    textarea { overflow: auto; }
    optgroup { font-weight: bold; }
    table { border-collapse: collapse; border-spacing: 0; }
    td, th { padding: 0; }
    """
  end
end

