class Property
  include Neo4j::ActiveNode

  include Authorizable

  property :name
end
