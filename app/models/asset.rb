
class Asset
  include Neo4j::ActiveNode

  property :title
  property :public, default: true

  property :created_at
  property :updated_at

  has_many :out, :categories, type: :HAS_CATEGORY

  has_many :in, :creators, type: :CREATED, model_class: :Person
end
