class Asset
  include Neo4j::ActiveNode
  include Neo4jrb::Paperclip

  include Authorizable

  property :title

  has_neo4jrb_attached_file :image
  validates_attachment_content_type :image, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  property :view_count, type: Integer

  property :private, type: Boolean

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

  def name
    title
  end

  def as_json(_options = {})
    {self.class.model_slug =>
      {id: id,
       title: title,
       name: title,
       image_url: image.url,
       model_slug: self.class.model_slug}
     }
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

  def self.authorized_for(user)
    require './lib/query_authorizer'
    QueryAuthorizer.new(all(:asset).categories(:category, nil, optional: true))
      .authorized_query([:asset, :category], user)
      .with('DISTINCT asset AS asset')
      .proxy_as(self, :asset)
  end

  def self.authorized_properties(user)
    query = properties_query

    require './lib/query_authorizer'
    query_authorizer = QueryAuthorizer.new(query)

    ::Property # rubocop:disable Lint/Void
    query_authorizer.authorized_pluck(:property, user)
  end

  def self.authorized_properties_and_levels(_user)
  end

  def self.properties_query
    property_name_and_uuid_query
      .merge(model: {Model: {name: name}})
      .on_create_set(model: {private: false})
      .break
      .merge('model-[:HAS_PROPERTY]->(property:Property {name: property_name})')
      .on_create_set(property: {private: false})
      .on_create_set('property.uuid = uuid')
      .with(:property)
  end

  def self.property_name_and_uuid_query
    properties_and_uuids = properties.map do |property|
      [property, SecureRandom.uuid]
    end

    Neo4j::Session.current.query
      .with('{properties_and_uuids} AS properties_and_uuids')
      .unwind('properties_and_uuids AS property_and_uuid')
      .params(properties_and_uuids: properties_and_uuids)
      .with('property_and_uuid[0] AS property_name, property_and_uuid[1] AS uuid')
  end
end
