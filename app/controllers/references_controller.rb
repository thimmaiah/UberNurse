class ReferencesController < ApplicationController
  before_action :set_reference, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @references = Reference.all
    respond_with(@references)
  end

  def show
    respond_with(@reference)
  end

  def new
    @reference = Reference.new
    respond_with(@reference)
  end

  def edit
  end

  def create
    @reference = Reference.new(reference_params)
    @reference.save
    respond_with(@reference)
  end

  def update
    @reference.update(reference_params)
    respond_with(@reference)
  end

  def destroy
    @reference.destroy
    respond_with(@reference)
  end

  private
    def set_reference
      @reference = Reference.find(params[:id])
    end

    def reference_params
      params.require(:reference).permit(:first_name, :last_name, :title, :email, :ref_type, :user_id)
    end
end
