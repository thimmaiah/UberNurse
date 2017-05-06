class UserDoc < ApplicationRecord

	DOC_TYPES = ["Certificate", "ID Card", "Address Proof"]

	has_attached_file :doc, {validate_media_type: false}
	validates_attachment_file_name :doc, matches: [/png\z/, /jpe?g\z/]

	after_save :verify_user
	def verify_user
		if(self.verified)
			VerifyUserJob.perform_later(self.user_id)	
		end
	end
end
