class AssetsController < ApplicationController
  def index
    @assets = Asset.all.with_associations(:categories)
  end

  def show
    @asset = Asset.find(params[:id])
  end
end
