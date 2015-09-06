class AssetsController < ApplicationController
  def home
  end

  def index
    @assets = model_class_scope.with_associations(:categories)
  end

  def show
    @asset = model_class_scope.find(params[:id])
  end

  def edit
    @asset = model_class_scope.find(params[:id])
  end

  def update
    @asset = model_class_scope.find(params[:id])
    @asset.update(params[:book])

    redirect_to action: :edit
  end

  def model_class_scope
    model_class.authorized_for(current_user)
  end
end
