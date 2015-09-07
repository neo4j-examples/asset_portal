class AuthorizablesController < ApplicationController
  before_action :require_admin

  def show
    @object = model_class.find(params[:id])
  end

  def update
    @object = model_class.find(params[:id])

    @object.update_attribute(:private, params[:private]) unless params[:private].nil?

    user_access_levels = access_levels_from_permissions(params[:user_permissions], :user)
    @object.set_access_levels(User, user_access_levels)

    group_access_levels = access_levels_from_permissions(params[:group_permissions], :group)
    @object.set_access_levels(Group, group_access_levels)

    render :show
  end

  def access_levels_from_permissions(permissions, type)
    (permissions || []).each_with_object({}) do |permission, result|
      result[permission[type][:id]] = permission[:level]
    end
  end

  def user_and_group_search
    @users, @groups = if params[:query].present?

                        [User.for_query(params[:query]), Group.for_query(params[:query])]
                      else
                        [[], []]
                      end
  end

  def change_permissions_modal
    render layout: false
  end
end
