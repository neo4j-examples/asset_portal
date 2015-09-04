class Book < Asset
  property :isbn13, type: String
  property :authors
  property :contributors
  property :publish_date, type: String

  property :abstract, type: :markdown

  # has_neo4jrb_attached_file :back_cover_image

  # has_many :in, :authors, type: :WROTE, model_class: :Person
end
