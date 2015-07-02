class RationalConverter
  class << self
    def primitive_type; String; end

    def convert_type; Rational; end

    def to_db(value)
      "#{value.numerator}/#{value.denominator}"
    end

    def to_ruby(value)
      value && Rational(value)
    end
    alias_method :call, :to_ruby
  end
  include Neo4j::Shared::Typecaster
end

class Asset 
  include Neo4j::ActiveNode

  id_property :code
  property :title, type: Integer
  property :price, type: Rational

  property :details
  serialize :details

  property :created_at
  property :updated_at
end
