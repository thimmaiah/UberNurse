class Rate < ApplicationRecord

  validates_presence_of :agency_id	
  
  belongs_to :agency
  belongs_to :care_home
  
  class << self
    include RatesHelper
  end

end
