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

  def authorized_query(variable, user)
    query.with(variable)
      .match_nodes(user: user)
      .where("#{variable}.public OR
  #{variable}<-[:CREATED]-user OR #{variable}-[:VIEWABLE_BY]->user OR
  #{variable}-[:VIEWABLE_BY]->(:Group)<-[:HAS_SUBGROUP*0..5]-(:Group)<-[:BELONGS_TO]-user")
  end

  private

  def validate_query_object!(query_object)
    return if self.class.is_queryish?(query_object)

    fail ArgumentError, "Expected query_object to be queryish.  Was: #{query_object.inspect}"
  end

  def self.is_queryish?(query_object)
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
