class Person < Asset
  has_many :out, :books, type: false
  has_many :out, :books_written, model_class: :Book, origin: :authors
  has_many :out, :books_contributed_to, model_class: :Book, origin: :contributors

  def name=(string)
    self.title = string
  end

  def name
    title
  end
end
