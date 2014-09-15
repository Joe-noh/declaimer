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
        text "Hello World"
        list :bullet do
          item "こんにちわ"
          item "世界"
        end
      end

      slide "Page 2", theme: :dark do
        code "markdown" do
          "# Head"
          "* one"
          "* two"
        end
      end
    end
    """
  end

  def config_exs do
    """
    use Mix.Config

    config :declaimer,
      source_exs: "presentation.exs",
      output_html: "presentation.html",
      highlight_js_theme: "hybrid"
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

      $(window).on("load resize", function() {
        var h = parseInt($(window).height());
        $("html").css("font-size", parseInt(h*0.018)+"px");
      });
    });
    """
  end

  def base_css do
    """
    body, html, .slide {
      font-size: 14px;
      height: 100%;
      width:  100%;
    }

    .slide {
      overflow: hidden;
    }

    @media screen {
      .slide.active {
        visibility: visible;
      }

      .slide.inactive {
        visibility: hidden;
        display: none;
      }
    }

    @media print {
      .slide.active, .slide.inactive {
        visibility: visible;
      }
    }

    .cover * {
      margin-left: 3rem;
    }

    .cover .title {
      margin-top: 4rem;
      font-size: 10rem;
    }

    .cover .subtitle {
      margin-top: 3rem;
      font-size: 6rem;
    }

    .cover .author {
      margin-top: 7rem;
      font-size: 5rem;
    }

    .cover .date {
      margin-top: 2rem;
      font-size: 4rem;
    }

    .slide:not(.cover) * {
      position: relative;
    }

    .slide h2 {
      margin: 1rem 0 2rem 3rem;
      font-size: 5rem;
    }

    .slide p {
      margin: 1rem 0 1rem 5rem;
      font-size: 4rem;
    }

    .slide .takahashi {
      height: 100%;
      width:  100%;
      display: table;
    }

    .slide .takahashi p {
      vertical-align: middle;
      text-align: center;
      display: table-cell;
      font-size: 10rem;
    }

    .slide ul {
      margin-left: 5rem;
      font-size: 4rem;
    }

    .slide ol {
      margin-left: 7rem;
      font-size: 4rem;
    }

    .slide li {
      margin-top: 0.5rem;
    }

    .slide > blockquote, .slide > pre {
      margin: 1rem auto;
      width: 90%;
    }

    .slide pre {
      font-size: 3rem;
    }

    .slide blockquote {
      background-color: #e8e8e8;
      font-size: 4rem;
      padding: 1rem;
    }

    .slide ul blockquote, .slide ol blockquote {
      width: 90%;
      font-size: inherit;
    }

    .slide table {
      margin: 1rem auto;
      width: 90%;
      font-size: 4rem;
    }

    .slide table, .slide td, .slide th {
      border: 1px black solid;
    }

    .slide img {
      margin: 1% auto;
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

    .left-half {
      width: 50%;
      float: left;
    }

    .right-half {
      width: 50%;
      float: right;
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

