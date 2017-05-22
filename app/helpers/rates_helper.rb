module RatesHelper
	def price(staffing_request)
	end

	def billing_rate(staffing_request)
		zone = Rate.where(zone: staffing_request.zone)
	end
end
