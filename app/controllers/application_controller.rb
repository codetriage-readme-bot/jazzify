class ApplicationController < ActionController::Base

  # Includes Authorization mechanism
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Globally rescue Authorization Errors in controller.
  # Returning 403 Forbidden if permission is denied
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  private

  def permission_denied
    head 403
  end

  def not_authorized
    redirect_to root_url, :alert => "You are not authorized to perform the requested action!"
  end

  def set_user
    @user = current_user
  end

end
