class AssetsController < ApplicationController
  def home
  end

  def index
    @assets = model_class_scope.with_associations(:categories)
  end

  def show
    @asset = asset

    render file: 'public/404.html', status: :not_found, layout: false if !@asset
  end

  def edit
    @asset = asset

    render file: 'public/404.html', status: :not_found, layout: false if !@asset
  end

  def update
    @asset = get_asset
    @asset.update(params[:book])

    redirect_to action: :edit
  end

  def asset
    model_class_scope.find(params[:id])
  end

  def model_class_scope
    model_class.authorized_for(current_user)
  end
end
