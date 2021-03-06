class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :nurse_type, 
  :sex, :title, :phone, :phone_verified, :address, :postcode, :languages, :pref_commute_distance, 
  :speciality, :experience, :referal_code, :accept_terms, :care_home_id, :care_home_ids, :sister_care_homes,
  :image, :can_manage, :verified, :sort_code, :bank_account, :rating, :user_docs, :push_token,
  :accept_bank_transactions, :accept_bank_transactions_date, :sms_verification_code

  has_many :user_docs, serializer: UserDocSerializer
  belongs_to :care_home, serializer: CareHomeSerializer

  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end

  def rating
  	(object.rating_count > 0) ? (object.total_rating/object.rating_count) : 0 
  end

  def user_docs
    object.user_docs.not_expired
  end

  def sister_care_homes
    object.care_homes if object.care_home && object.care_home.sister_care_homes
  end

end
