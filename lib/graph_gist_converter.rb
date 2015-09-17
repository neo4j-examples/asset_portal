class GraphGistConverter
  def initialize(asciidoc_text)
    @asciidoc_text = asciidoc_text.dup
  end

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

  def html
    COMMENT_REPLACEMENTS.each do |tag, replacement|
      @asciidoc_text.gsub!(Regexp.new(%r{^//\s*#{tag}}, 'gm'), "++++\n#{replacement}\n++++\n")
    end

    Asciidoctor.convert(@asciidoc_text, attributes: ASCIIDOC_ATTRIBUTES)
  end
end
