require 'graph_gist_converter'
require 'open-uri'

class GraphGist < Asset
  # TODO: constraint should be on URL without params string or trailing slashes
  property :url, type: String, constraint: :unique

  property :asciidoc, type: String
  property :html, type: String

  has_one :in, :author, type: :WROTE, model_class: :Person


  def body=(asciidoc_text)
    write_attribute(:asciidoc, asciidoc_text)

    render_html
  end

  def render_html
    self.html = GraphGistConverter.new(asciidoc).html
  end

  class << self
    def build_from_url(url)
      asciidoc_text = nil

      t = Benchmark.realtime do
        asciidoc_text = open(url).read
      end
      Rails.logger.debug "Retrieved #{url} in #{t.round(1)}s"

      new(body: asciidoc_text, private: false)
    end
  end
end
