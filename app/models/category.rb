class Category 
  include Neo4j::ActiveNode

  property :name

  has_many :in, :included_assets, origin: :categories, model_class: :Asset
end
