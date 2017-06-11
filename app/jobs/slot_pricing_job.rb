class SlotPricingJob < ApplicationJob
  queue_as :default

  def perform(shift_id)
    shift = Shift.find(shift_id)
    Rate.price_actual(shift)
    shift.save!
  end
end
