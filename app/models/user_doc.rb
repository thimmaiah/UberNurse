class UserDoc < ApplicationRecord
	has_attached_file :doc, {validate_media_type: false}
	validates_attachment_file_name :doc, matches: [/png\z/, /jpe?g\z/]

end
