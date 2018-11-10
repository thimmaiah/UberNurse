class Training < ApplicationRecord

	belongs_to :agency
	belongs_to :user
	belongs_to :profile

	validates_presence_of :user_id, :profile, :name, :date_completed
end
