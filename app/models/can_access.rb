class CanAccess
  include Neo4j::ActiveRel

  from_class :any # [:User, :Group] ?
  to_class :any

  creates_unique

  property :level, default: 'read'
  validates :level, inclusion: {in: ['read', 'write']}
end