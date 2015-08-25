
class Asset
  include Neo4j::ActiveNode
  include Neo4jrb::Paperclip


  property :title
  property :public, default: true

  has_neo4jrb_attached_file :image
  validates_attachment_content_type :image, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  property :view_count, type: Integer

  property :created_at
  property :updated_at

  has_many :out, :categories, type: :HAS_CATEGORY

  has_many :out, :allowed_users, type: :VIEWABLE_BY, model_class: :User
  has_many :out, :allowed_groups, type: :VIEWABLE_BY, model_class: :Group

  has_many :in, :creators, type: :CREATED, model_class: :User

  has_many :in, :viewers, rel_class: :View, model_class: :User

  SecretSauceRecommendation = Struct.new(:asset, :score)

  def secret_sauce_recommendations
    query_as(:source)
      .match('source-[:HAS_CATEGORY]->(category:Category)<-[:HAS_CATEGORY]-(asset:Asset)')
      .break
      .optional_match('source<-[:CREATED]-(creator:User)-[:CREATED]->asset')
      .break
      .optional_match('source<-[:VIEWED]-(viewer:User)-[:VIEWED]->asset')
      .limit(5)
      .order('score DESC')
      .pluck(
        :asset,
        '(count(category) * 2) +
         (count(creator) * 4) +
         (count(viewer) * 0.1) AS score').map do |other_asset, score|
      SecretSauceRecommendation.new(other_asset, score)
    end
  end

  def self.visible_to(user)
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


  def self.descendants
    Rails.application.eager_load! if Rails.env == 'development'
    Neo4j::ActiveNode::Labels._wrapped_classes.select { |klass| klass < self }
  end

  def self.model_slug
    name.tableize
  end

  def self.properties
    attributes.keys - Asset.attributes.keys
  end
end
