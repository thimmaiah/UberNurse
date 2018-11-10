class Rate < ApplicationRecord
  
  belongs_to :agency
  
  class << self
    include RatesHelper
  end

end
