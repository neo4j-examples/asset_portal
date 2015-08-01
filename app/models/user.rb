class User
  include Neo4j::ActiveNode
  property :name, type: String
  property :email, type: String

  property :created_at
  property :updated_at

  has_many :out, :created_assets, type: :CREATED, model_class: :Asset
  has_many :out, :viewed_assets, type: :VIEWED, model_class: :Asset
end
