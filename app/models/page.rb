class Page < ApplicationRecord
  include Leafable

  cattr_accessor :preview_renderer do
    renderer = Redcarpet::Render::HTML.new(ActionText::Markdown::DEFAULT_RENDERER_OPTIONS)
    Redcarpet::Markdown.new(renderer, ActionText::Markdown::DEFAULT_MARKDOWN_EXTENSIONS)
  end

  has_markdown :body

  def searchable_content
    plain_text
  end

  def html_preview
    rendered_html(markdown_source.first(1024))
  end

  private
    def plain_text
      html_body = rendered_html(markdown_source)
      ActionText::Content.new(html_body).to_plain_text
    end

    def rendered_html(source)
      preview_renderer.render(source)
    end

    def markdown_source
      body.content.to_s
    end
end
