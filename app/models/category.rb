class Category
  include Neo4j::ActiveNode

  property :name
  property :standardized_name, constraint: :unique

  property :created_at
  property :updated_at

  has_many :in, :assets, origin: :categories

  scope :ordered, -> { order(:name) }

  def self.most_recently_updated
    all.order(:updated_at).last
  end
end
