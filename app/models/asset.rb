class Asset 
  include Neo4j::ActiveNode
  property :title, type: String
  property :created_at, type: DateTime
  property :updated_at, type: DateTime

end
