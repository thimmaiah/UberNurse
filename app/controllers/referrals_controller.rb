class ReferralsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :referral_params


  respond_to :html

  def index
    @referrals = Referral.all
    respond_with(@referrals)
  end

  def show
    respond_with(@referral)
  end

  def new
    @referral = Referral.new
    respond_with(@referral)
  end

  def edit
  end

  def create
    @referral = Referral.new(referral_params)
    @referral.save
    respond_with(@referral)
  end

  def update
    @referral.update(referral_params)
    respond_with(@referral)
  end

  def destroy
    @referral.destroy
    respond_with(@referral)
  end

  private
    def set_referral
      @referral = Referral.find(params[:id])
    end

    def referral_params
      params.require(:referral).permit(:first_name, :last_name, :email, :role, :user_id)
    end
end
