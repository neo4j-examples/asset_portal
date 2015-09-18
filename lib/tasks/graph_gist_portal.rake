
require 'net/http'
require 'uri'


namespace :graph_gist_portal do

  def final_url(url)
    uri = URI.parse(url)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.head(uri.path.strip == '' ? '/' : uri.path)
    end

    res['location'] ? final_url(res['location']) : url
  end

  task import_legacy_db: :environment do
    legacy_db = Neo4j::Session.open(:server_db, ENV['LEGACY_GRAPHGIST_DB_URL']) 

    gists = legacy_db.query.match(gist: :Gist).pluck(:gist)

    puts 'Importing Gists'
    gists.each do |gist|
      props = gist.props
      updated_at = props[:updated] / 1000 if props[:updated].present?
      new_props = {
        legacy_neo_id: gist.neo_id,
        legacy_poster_image: props[:poster_image],
        summary: props[:summary],
        title: props[:title],
        status: props[:status],
        updated_at: updated_at,
        legacy_rated: props[:rated],
        url: props[:url],
        private: false
      }
      puts 'new_props', new_props.inspect
      graph_gist = GraphGist.find_or_create({legacy_db_id: props[:id]}, new_props)
      graph_gist.image = open(final_url(props[:poster_image])) if props[:poster_image].present?
      graph_gist.save
      putc '.'
    end
  end
end