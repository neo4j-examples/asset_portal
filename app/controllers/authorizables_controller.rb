class AuthorizablesController < ApplicationController
  before_action :require_admin

  before_action :set_object, only: [:show, :update]

  def show
  end

  def update
    @object.update_attribute(:private, params[:private])

    @object.set_access_levels User,
                              access_levels_from_permissions(params[:user_permissions], :user)

    @object.set_access_levels Group,
                              access_levels_from_permissions(params[:group_permissions], :group)

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

  private

  def set_object
    @object = model_class.find(params[:id])
  end
end
