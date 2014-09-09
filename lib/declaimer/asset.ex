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

      slide "Page 2", theme: :dark do
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

  def reset_css do
    """
    html,body,div,span,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,abbr,address,cite,code,del,
    dfn,em,img,ins,kbd,q,samp,small,strong,sub,sup,var,b,i,dl,dt,dd,ol,ul,li,fieldset,form,label,
    legend,table,caption,tbody,tfoot,thead,tr,th,td,article,aside,canvas,details,figcaption,figure,
    footer,header,hgroup,menu,nav,section,summary,time,mark,audio,video{
    margin:0;padding:0;border:0;outline:0;font-size:100%;vertical-align:baseline;background:transparent}
    body{line-height:1}
    article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section{display:block}
    nav ul{list-style:none}
    blockquote,q{quotes:none}
    blockquote:before,blockquote:after,q:before,q:after{content:none}
    a{margin:0;padding:0;font-size:100%;vertical-align:baseline;background:transparent}
    ins{background-color:#ff9;color:#000;text-decoration:none}
    mark{background-color:#ff9;color:#000;font-style:italic;font-weight:bold}
    del{text-decoration:line-through}
    abbr[title],dfn[title]{border-bottom:1px dotted;cursor:help}
    table{border-collapse:collapse;border-spacing:0}
    hr{display:block;height:1px;border:0;border-top:1px solid #ccc;margin:1em 0;padding:0}
    input,select{vertical-align:middle}
    """
  end
end

