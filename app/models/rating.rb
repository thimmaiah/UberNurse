class Rating < ApplicationRecord
	
	COMMENTS = ["Great Work", "Good Work", "Not Bad", "Can Improve"]
	
	belongs_to :staffing_response
	belongs_to :user
	belongs_to :created_by, class_name: "User", foreign_key: :created_by_id
	
	after_create :add_user_ratings
	after_create :response_rated
	before_destroy :delete_user_rating
	before_destroy :response_unrated

	def add_user_ratings
		self.user.total_rating = 0 if self.user.total_rating == nil
		self.user.rating_count = 0 if self.user.rating_count == nil
		
		self.user.total_rating = self.user.total_rating + self.stars
		self.user.rating_count = self.user.rating_count + 1
		self.user.save
	end

	def response_rated
		self.staffing_response.rated = true
		self.staffing_response.save
	end

	def delete_user_ratings
		self.user.total_rating =  self.user.total_rating + self.stars
		self.user.rating_count =  self.user.rating_count - 1
		self.user.save
	end

	def response_unrated
		self.staffing_response.rated = false
		self.staffing_response.save
	end
end
