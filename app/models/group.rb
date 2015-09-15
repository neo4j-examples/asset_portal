class Group
  include Neo4j::ActiveNode
  property :name, type: String

  property :created_at
  property :updated_at

  has_one :in, :parent, model_class: :Group, type: :HAS_SUBGROUP
  has_many :out, :sub_groups, model_class: :Group, type: :HAS_SUBGROUP

  has_many :in, :members, model_class: :User, origin: :groups

  def self.roots
    all(:group).where('NOT(group<-[:HAS_SUBGROUP]-())')
  end

  def self.for_query(query_string)
    query_regex = Regexp.new('.*' + query_string.gsub(/[\s\*]+/, '.*') + '.*', 'i')

    as(:group)
      .where('group.name =~ {query}')
      .params(query: query_regex)
  end

  def addable_users
    User.as(:user)
      .groups(:group, nil, optional: true)
      .where('group.uuid <> ?', id)
      .query.with(:user)
      .proxy_as(User, :user)
  end
end
