class SlotPricingJob < ApplicationJob
  queue_as :default

  def perform(staffing_response_id)
    staffing_response = StaffingResponse.find(staffing_response_id)
    Rate.price_actual(staffing_response)
    staffing_response.save!
  end
end
