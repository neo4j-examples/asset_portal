class Property
  include Neo4j::ActiveNode

  include Authorizable

  property :name
  property :created_at
  property :updated_at
end
