class View
  include Neo4j::ActiveRel

  from_class :User
  to_class :any
  type :VIEWED
  creates_unique

  property :viewed_at
  property :browser_string

  validates :browser_string, presense: true
  validates :ip_address, ip_address: true

  before_create :set_viewed_at

  def set_viewed_at
    self.viewed_at ||= Time.now
  end

  after_create :increment_destination_view_count
  
  def increment_destination_view_count
    (to_node.view_count ||= 0) += 1
    to_node.save
  end
end
