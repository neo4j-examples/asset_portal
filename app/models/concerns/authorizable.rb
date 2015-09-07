module Authorizable
  extend ActiveSupport::Concern

  included do
    property :private, type: ActiveAttr::Typecasting::Boolean, default: false
    validates :private, inclusion: {in: [true, false]}

    has_many :in, :allowed_users, rel_class: :CanAccess, model_class: :User
    has_many :in, :allowed_groups, rel_class: :CanAccess, model_class: :Group
  end

  def set_access_levels(model, access_levels)
    records_by_id = model.where(id: access_levels.keys).index_by(&:id)

    model.where_not(id: records_by_id.keys)
      .query_as(:r)
      .match_nodes(this: self)
      .match('r-[rel:CAN_ACCESS]->(this)')
      .delete(:rel).exec

    access_levels.each do |id, level|
      CanAccess.create(from_node: records_by_id[id], to_node: self, level: level)
    end
  end

  module ClassMethods
  end
end
