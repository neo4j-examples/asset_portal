
class Asset
  include Neo4j::ActiveNode

  property :title
  property :public, default: true

  property :created_at
  property :updated_at

  has_many :out, :categories, type: :HAS_CATEGORY

  has_many :out, :allowed_users, type: :VIEWABLE_BY, model_class: :User
  has_many :out, :allowed_groups, type: :VIEWABLE_BY, model_class: :Group

  has_many :in, :creators, type: :CREATED, model_class: :Person

  CategoryRecommendation = Struct.new(:asset, :categories, :score)

  def asset_recommendations_by_category(common_links_required = 3)
    categories(:c)
      .assets(:asset)
      .order('count(c) DESC')
      .pluck('asset, collect(c), count(c)').reject do |_, _, count|
      count < common_links_required
    end.map do |other_asset, categories, count|
      CategoryRecommendation.new(other_asset, categories, count)
    end
  end

  SecretSauceRecommendation = Struct.new(:asset, :score)

  def secret_sauce_recommendations
    query_as(:source)
      .match('source-[:HAS_CATEGORY]->(category:Category)<-[:HAS_CATEGORY]-(asset:Asset)').break
      .optional_match('source<-[:CREATED]-(creator:User)-[:CREATED]->asset').break
      .optional_match('source<-[:VIEWED]-(viewer:User)-[:VIEWED]->asset')
      .limit(5)
      .order('score DESC')
      .pluck(
        :asset,
        '(count(category) * 2) + (count(creator) * 4) + (count(viewer) * 0.1) AS score').map do |other_asset, score|
      SecretSauceRecommendation.new(other_asset, score)
    end
  end

  def visible_to(user)
    query_as(:asset)
      .match_nodes(user: user)
      .where("
asset.public OR
asset<-[:CREATED]-user OR asset-[:VIEWABLE_BY]->user OR
asset-[:VIEWABLE_BY]->(:Group)<-[:HAS_SUBGROUP*0..5]-(:Group)<-[:BELONGS_TO]-user
")
      .pluck(:asset)
    # proxy_as(Asset, :asset)
  end
end
