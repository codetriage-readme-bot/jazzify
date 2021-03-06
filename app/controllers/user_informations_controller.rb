class UserInformationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_user_information, only: [:show, :edit, :update, :destroy]
  before_action :application_locked?, except: [:index, :show]

  after_action :verify_authorized, except: :index
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  respond_to :html

  # Show all user informations.
  def index
    registered_user_information = UserInformation.find_by(user_id: "#{@user.id}")
    if !@user.is_elevated?
      if registered_user_information.nil?
        redirect_to new_user_information_url
      else
        redirect_to user_information_url registered_user_information.id
      end
    else
      @user_informations = UserInformation.all.order(updated_at: :desc).page(params[:page])
      authorize @user_informations
      respond_with(@user_informations)
    end
  end

  # Show a users information.
  def show
    set_user_information
    authorize @user_information
    respond_with(@user_information)
  end

  # Open the new user information page.
  def new
    @user_information = UserInformation.new
    authorize @user_information
    @user_information.user_id = @user.id
    respond_with(@user_information)
  end

  # Open the edit user information page.
  def edit
    authorize @user_information
  end

  # Add a user's information to the database.
  def create
    @user_information = UserInformation.new(user_information_params)
    authorize @user_information
    @user_information.updated_by = @user.id
    @user_information.save
    if session[:return_to] and @user_information.valid?
      link = session[:return_to]
      session[:return_to] = nil
      redirect_to link
    else
      respond_with(@user_information)
    end
  end

  # Update the user's information.
  def update
    authorize @user_information
    @user_information.updated_by = @user.id
    @user_information.update(user_information_params)
    respond_with(@user_information)
  end

  # Delete a user information.
  # If the user applied, the application must be deleted first.
  def destroy
    authorize @user_information
    if @user_information.user.user_application
      if @user.is_elevated? and @user_information.user != @user
        flash[:warning] = "The user has an application that depends on this. Delete it first."
      else
        flash[:warning] = "Your application depends on this information. Delete it first."
      end
      redirect_to user_informations_path and return
    end
    @user_information.destroy
    respond_with(@user_information)
  end

  private
    def set_user_information
      @user_information = UserInformation.find(params[:id])
    end

    # Define which paramaters are permitted when submitting a request to this resource.
    def user_information_params
      params.require(:user_information)
        .permit(:user_id, :first_name, :last_name, :address, :city,
        :province, :postal_code, :home_phone_number, :work_phone_number,
        :cell_phone_number, :t_shirt_size, :age_group, :emergency_contact_name,
        :emergency_contact_number, :notes, :availability, :unavailability, :code_of_conduct)
    end

    def not_authorized(params)
    redirect_to user_informations_url, alert: 'You are not authorized to perform the requested action!'
  end
end
