class ModelsController < ApplicationController
  def index
    @models = Model.all
  end

  def show
    @model = Model.find_by(name: params[:name])
  end
end
