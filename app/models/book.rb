class Book < Asset
  property :isbn13, type: String
  property :publish_date, type: String

  property :first_year_sales, type: Integer

  property :some_datetime, type: DateTime
  property :some_date, type: Date

  has_many :in, :authors, type: :WROTE, model_class: :Person
  has_many :in, :contributors, type: :CONTRIBUTED_TO, model_class: :Person

  # has_neo4jrb_attached_file :back_cover_image

  # has_many :in, :authors, type: :WROTE, model_class: :Person
end
