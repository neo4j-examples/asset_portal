
class Asset 
  include Neo4j::ActiveNode

  property :title

  has_many :out, :categories, type: :HAS_CATEGORY
end

