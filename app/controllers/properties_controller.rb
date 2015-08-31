class PropertiesController < ApplicationController
  def index
    @properties = Property.all
  end

  def show
    @property = Property.find(params[:id])
  end
end
