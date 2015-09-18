require 'graph_gist_converter'
require 'open-uri'

class GraphGist < Asset
  # TODO: constraint should be on URL without params string or trailing slashes
  property :url, type: String, constraint: :unique
  property :raw_url, type: String

  property :asciidoc, type: String
  validates :asciidoc, presence: true
  property :html, type: String
  validates :html, presence: true

  property :status, type: String
  validates :status, inclusion: {in: %w(live disabled candidate)}

  has_one :in, :author, type: :WROTE, model_class: :Person

  property :legacy_db_id, type: String

  def body=(asciidoc_text)
    self[:asciidoc] = asciidoc_text

    render_html
  end

  def url=(new_url)
    super

    self.raw_url = GraphGistTools.raw_url_for(url)
  end

  def render_html
    self.html = GraphGistTools.adoc2html(asciidoc)
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
