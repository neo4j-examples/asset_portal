class QueryAuthorizer
  # Can take:
  #  * a Query
  #  * a Proxy object
  #  * Anything that responds to #query where a `Query` is returned
  def initialize(query_object)
    validate_query_object!(query_object)

    @query_object = query_object
  end

  def authorized_pluck(variable, user)
    authorized_query(variable, user).pluck(variable)
  end

  def authorized_query(variables, user)
    variables = Array(variables)


    result_query = query.with(*variables)

    where_clause = variables.map do |variable|
      "NOT(#{variable}.private) OR user.admin"
    end.join(' OR ')

    if user
      where_clause = where_clause + ' OR ' + variables.map do |variable|
        "#{variable}<-[:CREATED]-user OR #{variable}<-[:CAN_ACCESS]-user OR
    #{variable}<-[:CAN_ACCESS]-(:Group)<-[:HAS_SUBGROUP*0..5]-(:Group)<-[:BELONGS_TO]-user"
      end.join(' OR ')

      result_query = result_query.match_nodes(user: user)
    end

    result_query.where(where_clause)
  end

  private

  def validate_query_object!(query_object)
    return if self.class.queryish?(query_object)

    fail ArgumentError, "Expected query_object to be queryish.  Was: #{query_object.inspect}"
  end

  def self.queryish?(query_object)
    query_object.is_a?(::Neo4j::Core::Query) ||
      # Working around these two classes for new.  They should return `true`
      # for `respond_to(:query)`
      query_object.is_a?(::Neo4j::ActiveNode::HasN::AssociationProxy) ||
      query_object.is_a?(::Neo4j::ActiveNode::Query::QueryProxy) ||
      query_object.respond_to?(:query)
  end

  def query
    if @query_object.is_a?(::Neo4j::Core::Query)
      @query_object
    else
      @query_object.query
    end
  end
end
