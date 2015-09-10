module ApplicationHelper
  def asset_path(asset)
    super(id: asset, model_slug: asset.class.model_slug)
  end
end
