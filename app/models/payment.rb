class Payment < ApplicationRecord

	validates_presence_of :agency_id

	acts_as_paranoid
	after_save ThinkingSphinx::RealTime.callback_for(:payment)
	
	belongs_to :agency
	belongs_to :user
	belongs_to :care_home
	belongs_to :shift
	belongs_to :staffing_request
	belongs_to :paid_by, class_name: "User", foreign_key: :paid_by_id	

	after_create :update_payment_status
	before_destroy :revert_payment_status

	def update_payment_status
		if(self.shift)
			self.shift.payment_status = "Pending"
			self.shift.care_home_payment_status = "Pending"
			self.shift.save
		end
	end

	def revert_payment_status
		if(self.shift)
			self.shift.payment_status = nil
			self.shift.care_home_payment_status = nil
			self.shift.save
		end
	end

	INCENTIVE = {
					"Care Giver" => {"24-48" => 0.25, "48-72" => 0.5, ">72" => 1.0},
					"Nurse" 	 => {"24-48" => 1.5,  "48-72" => 2.5, ">72" => 5.0}
				}

	def self.generate_incentive(user, date)
		hours_worked = (user.mins_worked_in_month(date) / 60).round(0)
		logger.debug "Payment.generate_incentive: User #{user.id} worked #{hours_worked} hours for month #{date.beginning_of_month}"
		key = nil
		if(hours_worked >= 24 && hours_worked < 48)
			key = "24-48"
		elsif (hours_worked >= 48 && hours_worked < 72)
			key = "48-72"
		elsif (hours_worked >= 72)		
			key = ">72"
		end


		if( INCENTIVE[user.role] && INCENTIVE[user.role][key] )

			# Compute the hours worked
			incentive_amount = hours_worked * INCENTIVE[user.role][key]
			vat = incentive_amount * ENV["VAT"].to_f.round(2)
			total_amount = incentive_amount + vat 
			logger.debug "Payment.generate_incentive: incentive_amount = #{incentive_amount}"
			# Check if the incentive payment has already been generated
			incentive_payment = Payment.where(user_id: user.id, created_at: date.end_of_month).first
			# If not generate the incentive	
			if(incentive_payment != nil)
				logger.debug "Incentive already generate for this month. Skipping"
				return incentive_payment
			else
				logger.debug "Generating Incentive for this month #{date.end_of_month}."
				payment = Payment.new(user_id: user.id, 
						  amount: total_amount, 
						  vat: vat, care_giver_amount: incentive_amount,
						  created_at: date.end_of_month,
						  notes: "Incentive payment month ending #{date.end_of_month}, hours #{hours_worked}.")
				payment.save!
				return payment
			end
		else
			logger.debug "Generating no incentive for #{user.id} for #{hours_worked} hours in month #{date.end_of_month}."
		end
		
	end
end
