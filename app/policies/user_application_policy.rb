class UserApplicationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  attr_reader :user, :user_application

  def initialize(user, user_application)
		@user = user
		@user_application = user_application
  end

  def index?
    @user.is_elevated?
  end

  def new?
    true
  end

  def create?
    grant_access?
  end

  def show?
  	@user_application.user_id == @user.id or @user.is_elevated?
  end

  def view?
    show?
  end

  def review?
    @user.is_elevated?
  end

	def edit?
		grant_access?
	end

	def update?
		grant_access?
	end

	def destroy?
		grant_access?
	end

  def accept_or_deny?
    @user.is_elevated?
  end

  def reset?
    @user.is_elevated?
  end

  def success?
    true
  end

	private
	def grant_access?
    # If the user is an admin, just let them do whatever
    if @user.is_admin?
      return true

    # If the user is a moderator, they can't change an application user
    elsif @user.is_moderator?
      unchanged_application = UserApplication.find(@user_application.id)
      granted = @user_application.user_id == unchanged_application.user_id
      return granted

    # The user can't apply on behalf of another user, and cannot accept or deny their own application
    else
      user_application_status_for_user = UserApplicationStatus.find_by(status: "Pending")
      granted = user_application_status_for_user.id == @user_application.user_application_status_id.to_i
      granted = granted and @user.id == @user_application.user_id
      unless @user_application.created_at.nil?
        granted = granted and (DateTime.now < (@user_application.created_at + 24.hours))
      end
      return granted
    end
	end


end
