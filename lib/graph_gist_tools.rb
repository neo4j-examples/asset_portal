require 'json'
require 'open-uri'

module GraphGistTools
  ASCIIDOC_ATTRIBUTES = ['showtitle', 'env-graphgist']

  COMMENT_REPLACEMENTS = {
    console: '<p class="console"><span class="loading"><i class="icon-cogs"></i> Running queries, preparing the console!</span></p>',

    graph_result: '<h5 class="graph-visualization" graph-mode="result"><i class="huge spinner loading icon"></i></h5>',
    graph: '<h5 class="graph-visualization">Loading graph...<i class="huge spinner loading icon"></i></h5>',
    table: '<h5 class="result-table">Loading table...<i class="huge spinner loading icon"></i></h5>',

    hide: '<span class="hide-query"></span>',
    setup: '<span class="setup"></span>',
    output: '<span class="query-output"></span>'
  }

  def self.adoc2html(asciidoc_text)
    text = asciidoc_text.dup
    COMMENT_REPLACEMENTS.each do |tag, replacement|
      text.gsub!(Regexp.new(%r{^//\s*#{tag}}, 'gm'), "++++\n#{replacement}\n++++\n")
    end

    Asciidoctor.convert(text, attributes: ASCIIDOC_ATTRIBUTES)
  end

  def self.raw_url_for(url)
    case url
    when %r{^https?://gist.github.com/([^/]+/)?(.+)$}
      data = JSON.load(open("https://api.github.com/gists/#{$2}").read)

      fail ArgumentError, "Gist has more than one file!" if data['files'].size > 1

      data['files'].to_a[0][1]['raw_url']
    end
  end
end
