class Category 
  include Neo4j::ActiveNode

  property :name

  has_many :in, :assets, origin: :categories
end
