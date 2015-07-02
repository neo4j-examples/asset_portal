class AssetsController < ApplicationController
  def index
    @assets = Asset.all
  end
end
