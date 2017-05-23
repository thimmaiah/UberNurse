class Rate < ApplicationRecord
  
  class << self
    include RatesHelper
  end

end
