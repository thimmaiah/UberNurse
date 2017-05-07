class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :nurse_type, 
  :sex, :phone, :address, :languages, :pref_commute_distance, 
  :occupation, :speciality, :experience, :referal_code, :accept_terms, :hospital_id,
  :image, :can_manage, :verified, :sort_code, :bank_account, :rating, :user_docs

  has_many :user_docs, serializer: UserDocSerializer

  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end

  def rating
  	(object.rating_count > 0) ? (object.total_rating/object.rating_count) : 0 
  end

end
