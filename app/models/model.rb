class Model
  include Neo4j::ActiveNode

  include Authorizable

  id_property :name

  has_many :out, :properties, origin: :model

  def ruby_model
    name.constantize
  end

  def authorized_properties(user)
    require './lib/query_authorizer'
    query_authorizer = QueryAuthorizer.new(properties(:property))

    query_authorizer.authorized_pluck(:property, user)
  end
end
