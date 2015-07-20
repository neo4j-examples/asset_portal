class Category
  include Neo4j::ActiveNode

  property :name

  property :created_at
  property :updated_at

  has_many :in, :assets, origin: :categories
end
