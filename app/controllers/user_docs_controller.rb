class UserDocsController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  load_and_authorize_resource param_method: :user_doc_params

  before_action :set_user_doc, only: [:show, :update, :destroy]

  # GET /user_docs
  def index
    render json: @user_docs
  end

  # GET /user_docs/1
  def show
    render json: @user_doc
  end

  # POST /user_docs
  def create
    @user_doc = UserDoc.new(user_doc_params)
    # The doc could be uploaded by Super - so make sure we capture that
    # see UserDoc.dbs_charge()
    @user_doc.created_by_user_id = current_user.id    
    if @user_doc.save      
      render json: @user_doc, status: :created, location: @user_doc
    else
      puts "Errors #### " 
      puts @user_doc.errors.full_messages
      render json: @user_doc.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_docs/1
  def update
    if @user_doc.update(user_doc_params)
      render json: @user_doc
    else
      render json: @user_doc.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_docs/1
  def destroy
    @user_doc.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_doc
      @user_doc = UserDoc.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_doc_params
      params.require(:user_doc).permit(:name, :doc_type, :user_id, :doc, :notes, :verified)
    end
end
