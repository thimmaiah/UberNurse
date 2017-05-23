class CqcRecordsController < ApplicationController
  before_action :set_cqc_record, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @cqc_records = CqcRecord.all
    respond_with(@cqc_records)
  end

  def show
    respond_with(@cqc_record)
  end

  def new
    @cqc_record = CqcRecord.new
    respond_with(@cqc_record)
  end

  def edit
  end

  def create
    @cqc_record = CqcRecord.new(cqc_record_params)
    @cqc_record.save
    respond_with(@cqc_record)
  end

  def update
    @cqc_record.update(cqc_record_params)
    respond_with(@cqc_record)
  end

  def destroy
    @cqc_record.destroy
    respond_with(@cqc_record)
  end

  private
    def set_cqc_record
      @cqc_record = CqcRecord.find(params[:id])
    end

    def cqc_record_params
      params.require(:cqc_record).permit(:name, :aka, :address, :postcode, :phone, :website, :service_types, :services, :local_authority, :region, :cqc_url, :cqc_location)
    end
end
