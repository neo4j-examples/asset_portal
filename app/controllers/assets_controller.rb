class AssetsController < ApplicationController
  def home
  end

  def index
    @assets = model_class.all.with_associations(:categories)
  end

  def show
    @asset = model_class.find(params[:id])
  end

  def edit
    @asset = model_class.find(params[:id])
  end

  def update
    @asset = model_class.find(params[:id])
    @asset.update(params[:book])

    redirect_to action: :edit
  end
end
