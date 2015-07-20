class Group
  include Neo4j::ActiveNode
  property :name, type: String

  property :created_at
  property :updated_at

  has_one :in, :parent, model_class: :Group, type: :HAS_SUBGROUP
  has_many :out, :sub_groups, model_class: :Group, type: :HAS_SUBGROUP

  has_many :in, :members, model_class: :Group, origin: :groups
end
