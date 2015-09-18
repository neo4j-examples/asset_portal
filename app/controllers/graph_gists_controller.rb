class GraphGistsController < ApplicationController
  def preview
    @asset = GraphGist.build_from_url(params[:url])

    render 'graph_gists/show'
  end

  def search
    graph_gists = GraphGist.for_query(params[:query])

    data = graph_gists.map do |graph_gist|
      {
        title: graph_gist.title,
        description: graph_gist.author && graph_gist.author.name,
        url: asset_path(id: graph_gist.id, model_slug: :graph_gists)
      }
    end

    render text: {results: data}.to_json
  end

  def preview2
    graph_gist = GraphGist.create_from_url(params[:url])

    if graph_gist
      redirect_to controller: :assets, action: :show, model_slug: :graph_gists, id: graph_gist.id
    else
      flash[:error] = "Could not create GraphGist: #{graph_gist.errors.messages.join('/')}"
      redirect_to action: :submit
    end
  end
end
