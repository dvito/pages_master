# Working as of Jekyll 1.0.3
module Jekyll

  class WrapHighlightBlock < Jekyll::Tags::HighlightBlock
    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      '<figure class="code"><figcaption></figcaption>' + super + '</figure>'
      # I use gist for big code blocks, so I wanted to make my jekyll highlighting
      # reflect the same node tree for keeping styles dry
      # '<div class="gist-file"><div class="gist-data gist-syntax"><div class="line">' + super + '</div></div></div>'
    end
  end
end

Liquid::Template.register_tag('overhighlight', Jekyll::WrapHighlightBlock)