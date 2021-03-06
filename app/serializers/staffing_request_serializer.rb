class StaffingRequestSerializer < ActiveModel::Serializer
  
  

  attributes :id, :care_home_id, :user_id, :start_date, :end_date, :rate_per_hour, :role, :speciality,
  :request_status, :auto_deny_in, :response_count, :payment_status, :user, :care_home, 
  :broadcast_status, :can_manage, :start_code, :end_code, :carer_base, :care_home_base, 
  :care_home_total_amount, :vat, :pricing_audit, :created_at, :updated_at, :notes

  attribute :shifts

  belongs_to :user, serializer: UserMiniSerializer

  def can_manage
  	ability = Ability.new(scope)
  	ability.can?(:manage, object)
  end

  # We need to always send Lon dates back - as the time should be Lon time
  def start_date
  	object.start_date.in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
  end

  def end_date
  	object.end_date.in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
  end

  def created_at
    object.created_at.in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
  end

end
