
class Asset
  include Neo4j::ActiveNode
  include Neo4jrb::Paperclip

  include Authorizable

  property :title

  has_neo4jrb_attached_file :image
  validates_attachment_content_type :image, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  property :view_count, type: Integer

  property :created_at
  property :updated_at

  has_many :out, :categories, type: :HAS_CATEGORY

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

  def as_json(options = {})
    {id: id,
     title: title,
     image_url: image.url,
     model_slug: self.class.model_slug}
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

  def self.authorized_properties(user)
    query = Neo4j::Session.current.query
      .with("{property_names} AS property_names")
      .unwind(property_name: :property_names)
      .break
      .merge(model: {Model: {name: name}})
      .on_create_set(model: {public: true})
      .break
      .merge('model-[:HAS_PROPERTY]->(property:Property {name: property_name})')
      .on_create_set(property: {public: true})
      .params(property_names: properties)

    require './lib/query_authorizer'
    query_authorizer = QueryAuthorizer.new(query)

    query_authorizer.authorized_query(:property, user).pluck('property.name')
  end
end
