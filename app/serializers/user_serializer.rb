class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :nurse_type, 
  :sex, :phone, :phone_verified, :address, :postcode, :languages, :pref_commute_distance, 
  :speciality, :experience, :referal_code, :accept_terms, :care_home_id, :care_home,
  :image, :can_manage, :verified, :sort_code, :bank_account, :rating, :user_docs, :push_token,
  :accept_bank_transactions, :accept_bank_transactions_date

  has_many :user_docs, serializer: UserDocSerializer

  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end

  def rating
  	(object.rating_count > 0) ? (object.total_rating/object.rating_count) : 0 
  end

  def user_docs
    object.user_docs.not_expired
  end

end
