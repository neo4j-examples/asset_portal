class User
  include Neo4j::ActiveNode
  property :name, type: String
  property :username, type: String, index: :exact
  property :email, type: String, index: :exact
  validates :email, presence: true
  property :encrypted_password, type: String # REPLACE WITH DEVISE

  ## Rememberable
  property :remember_created_at, :type => DateTime
  index :remember_token

  ## Recoverable
  property :reset_password_token
  index :reset_password_token
  property :reset_password_sent_at, :type =>   DateTime

  ## Trackable
  property :sign_in_count, :type => Integer, :default => 0
  property :current_sign_in_at, :type => DateTime
  property :last_sign_in_at, :type => DateTime
  property :current_sign_in_ip, :type =>  String
  property :last_sign_in_ip, :type => String

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  property :view_count, type: Integer

  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  has_many :out, :groups, type: :BELONGS_TO

  has_many :out, :created_assets, type: :CREATED, model_class: :Asset
  has_many :out, :allowed_assets, rel_class: :CanAccess, model_class: :Asset
  has_many :out, :viewed_assets, rel_class: :View, model_class: :Asset
  has_many :out, :viewed_users,  rel_class: :View, model_class: :User

  has_many :in, :viewers, rel_class: :View, model_class: :User

  def self.for_query(query_string)
    query_regex = Regexp.new('.*' + query_string.gsub(/[\s\*]+/, '.*') + '.*')

    as(:user)
      .where('user.name =~ {query} OR user.username =~ {query} OR user.email =~ {query}')
      .params(query: query_regex)
  end

  def viewable_assets
    Asset.visible_to(self)
  end

  def can_change_permissions?
    true
  end
end
