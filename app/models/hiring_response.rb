class HiringResponse < ApplicationRecord
	belongs_to :user
	belongs_to :hiring_request
end
