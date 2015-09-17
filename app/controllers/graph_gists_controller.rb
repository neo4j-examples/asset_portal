class GraphGistsController < ApplicationController
  def preview
    @asset = GraphGist.build_from_url(params[:url])

    render 'graph_gists/show'
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
