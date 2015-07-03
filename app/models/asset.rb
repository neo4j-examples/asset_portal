
class Asset 
  include Neo4j::ActiveNode

  property :title

  has_many :out, :categories, type: :HAS_CATEGORY
  has_many :both, :see_also_assets, type: :OFTEN_VIEWED_WITH, model_class: :Asset
end

