class Property
  include Neo4j::ActiveNode

  include Authorizable

  property :name
  property :created_at
  property :updated_at

  has_one :in, :model, type: :HAS_PROPERTY

  def attribute_object
    model.ruby_model.attributes[name]
  end

  def ruby_type
    attribute_object[:type]
  end
end
