class Book < Asset
  property :isbn13, type: String
  property :authors
  property :contributors
  property :publish_date, type: String
end
