class ShiftSerializer < ActiveModel::Serializer
  attributes :id, :staffing_request_id, :user_id, :start_code, :start_date, 
  :end_code, :end_date, :response_status, :minutes_worked, :price, :pricing_audit, :viewed,
  :accepted, :rated, :care_home_rated, :user, :ratings, :care_home_id, :care_home, :staffing_request, :payment, :payment_status, :can_manage

  belongs_to :user, serializer: UserMiniSerializer
  has_many :ratings, serializer: RatingSerializer
  
  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end

  # We need to always send Lon dates back - as the time should be Lon time
  def start_date
  	object.start_date.in_time_zone("London").strftime("%Y-%m-%dT%H:%M") if object.start_date
  end

  def end_date
  	object.end_date.in_time_zone("London").strftime("%Y-%m-%dT%H:%M") if object.end_date
  end

end
