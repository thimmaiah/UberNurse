class UserDoc < ApplicationRecord

  belongs_to :user

  acts_as_paranoid
  after_save ThinkingSphinx::RealTime.callback_for(:user_doc)
  validates_presence_of :doc_type, :user_id, :name

  DOC_TYPES = ["Certificate", "ID Card", "Address Proof", "DBS"]

  has_attached_file :doc, {validate_media_type: false}
  validates_attachment_file_name :doc, matches: [/png\z/, /jpe?g\z/]

  scope :not_rejected, -> { where "verified = true or verified is null" }
  scope :not_expired, -> { where "expired = false" }

  scope :certificates, -> { where doc_type: "Certificate" }
  scope :id_cards, -> { where doc_type: "ID Card" }
  scope :address_proofs, -> { where doc_type: "Address Proof" }
  scope :dbs, -> { where doc_type: "DBS" }

  after_save :verify_user
  def verify_user
    if(self.verified)
      VerifyUserJob.perform_later(self.user_id)
    end
  end

  before_create :ensure_flags
  def ensure_flags
    self.expired = false
  end

  after_create :dbs_charge

  def dbs_charge
    if(self.doc_type == "DBS" && self.user_id != self.created_by_user_id)
      # The super uploaded the DBS
      # Charge the user for it
      # TODO
    end
  end

  def doc_url
    self.doc.url
  end
end
