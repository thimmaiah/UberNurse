class UsersController < ApplicationController

  before_action :authenticate_user!, except: [:unsubscribe, :resend_confirmation]
  load_and_authorize_resource param_method: :user_params,
    except: [:unsubscribe, :send_sms_verification, :verify_sms_verification, :resend_confirmation]

  # GET /users
  def index
    #@users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def unsubscribe
    user = User.find_by_unsubscribe_hash(params[:unsubscribe_hash])
    Rails.logger.info "unsubscribe called for #{user.email}"
    user.update_attribute(:subscription, false)
    redirect_to ENV['REDIRECT_UNSUBSCRIBE']
  end

  def send_sms_verification
    current_user.send_sms_verification()
  end

  def verify_sms_verification
    if current_user.confirm_sms_verification(params[:code])
      render json: {verified: true}
    else
      render json: {verified: false}
    end
  end

  def resend_confirmation
    user = User.find_by_email(params[:email])
    if(user)
      user.send_confirmation_instructions
      render json: {sent: true}
    else
      render json: {sent: false, user_not_found: true}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :nurse_type,
                                 :sex, :title, :phone, :postcode, :languages, :pref_commute_distance, :speciality, :experience,
                                 :referal_code, :accept_terms, :care_home_id, :image_url, :verified,
                                 :active, :sort_code, :bank_account, :push_token, 
                                 :accept_bank_transactions)
  end
end
