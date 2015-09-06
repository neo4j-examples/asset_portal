class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_admin
    @current_user_is_admin = current_user && current_user.admin?

    unless @current_user_is_admin
      return render text: 'Unauthorized', status: :unauthorized
    end
  end

  protected

  def model_class
    @model_slug = params[:model_slug]
    @model_slug.classify.constantize
  end
end
