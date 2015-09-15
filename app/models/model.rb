class Model
  include Neo4j::ActiveNode

  include Authorizable

  id_property :name

  has_many :out, :properties, type: :HAS_PROPERTY

  def authorized_properties(user)
    require './lib/query_authorizer'
    query_authorizer = QueryAuthorizer.new(properties(:property))

    query_authorizer.authorized_pluck(:property, user)
  end
end
