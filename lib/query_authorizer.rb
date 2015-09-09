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

    result_query = authorized_user_query(result_query, user, variables)

    # Collapse 2D array of all possible levels into one column of levels
    result_query
      .unwind(level_collection: :level_collections)
      .unwind(level: :level_collection).break
      .with(:level, *variables).where_not(level: nil)
      .with('collect(level) AS levels', *variables)
      .with("CASE WHEN 'write' IN levels THEN 'write' ELSE 'read' END AS level", *variables)
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

  def authorized_user_query(query, user, variables, user_variable = :user)
    collect_levels_string = variables.flat_map do |variable|
      ["CASE WHEN (user.admin OR #{variable}_created_rel IS NOT NULL) THEN 'write' WHEN NOT(#{variable}.private) THEN 'read' END",
       "#{variable}_direct_access_rel.level",
       "#{variable}_indirect_can_access_rel.level"]
    end.compact.join(', ')

    result_query = variables.flat_map { |v| user_authorization_paths(v, user_variable) }
                   .inject(query.optional_match_nodes(user_variable => user).break) do |result, clause|
      result.optional_match(clause).break
    end.with('*')

    result_query
      .with("collect([#{collect_levels_string}]) AS level_collections", *variables)
  end

  def user_authorization_paths(variable, user_variable = :user)
    ["#{variable}<-[#{variable}_created_rel:CREATED]-#{user_variable}",
     "#{variable}<-[#{variable}_direct_access_rel:CAN_ACCESS]-#{user_variable}",
     "#{variable}<-[#{variable}_indirect_can_access_rel:CAN_ACCESS]-(:Group)<-[:HAS_SUBGROUP*0..5]-(:Group)<-[:BELONGS_TO]-#{user_variable}"]
  end
end
