require 'graph_gist_converter'
require 'open-uri'

class GraphGist < Asset
  property :body, type: String
  property :url, type: String, constraint: :unique
  # TODO: constraint should be on URL without params string or trailing slashes

  property :html_body, type: String

  has_one :in, :author, type: :WROTE, model_class: :Person


  before_save :render_body

  def render_body
    self.html_body = GraphGistConverter.new(body).html
  end

  class << self
    def create_from_url(url)
      asciidoc_text = open(url).read

      create(body: asciidoc_text, private: false)
    end
  end

end