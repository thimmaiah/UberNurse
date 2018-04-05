class ShiftCloseJob < ApplicationJob
  queue_as :default

  def perform(shift_id)
  	Rails.logger.info "ShiftCloseJob: Start"


    # Price it
    shift = Shift.find(shift_id)
    Rate.price_actual(shift)
    shift.response_status = "Closed"

    Rails.logger.info "ShiftCloseJob priced shift #{shift.id} @ #{shift.price}"

    # generate a payment record
    payment = Payment.new(shift_id: shift.id, user_id: shift.user_id, 
      care_home_id: shift.care_home_id, paid_by_id: shift.staffing_request.user_id,
      amount: shift.total_price, notes: "Thank you for your service.",
      staffing_request_id: shift.staffing_request_id)
    
    req = shift.staffing_request
    req.request_status = "Closed"

    Shift.transaction do
      shift.save
      req.save
      payment.save
    end


    Rails.logger.info "ShiftCloseJob: Closed request #{req.id} & shift #{shift.id} with payment #{payment.id}"
    
    Rails.logger.info "ShiftCloseJob: End"

  end
end
