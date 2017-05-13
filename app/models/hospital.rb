class Hospital < ApplicationRecord

  acts_as_paranoid
  after_save ThinkingSphinx::RealTime.callback_for(:hospital)

  has_many :users
  has_many :staffing_requests


  reverse_geocoded_by :lat, :lng do |obj,results|
    if geo = results.first
      obj.address = geo.address.sub(geo.city + ", ", '').sub(geo.postal_code + ", ", '').sub("UK", '')
      obj.town    = geo.city
    end
  end

  before_save :update_coordinates
  def update_coordinates
    if(self.postcode_changed?)
      GeocodeJob.perform_later(self)
    end
  end

end
