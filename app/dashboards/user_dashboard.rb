require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    hospital: Field::BelongsTo,
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    email: Field::String,
    role: Field::String,
    nurse_type: Field::String,
    sex: Field::String,
    phone: Field::String,
    address: Field::Text,
    languages: Field::String,
    pref_commute_distance: Field::Number,
    occupation: Field::String,
    speciality: Field::String,
    experience: Field::Number,
    accept_terms: Field::Boolean,
    active: Field::Boolean,
    image_url: Field::Text,
    sort_code: Field::String,
    bank_account: Field::String,
    verified: Field::Boolean,
    postcode: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :hospital,
    :first_name,
    :last_name,
    :email,
    :role
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :hospital,
    :id,
    :first_name,
    :last_name,
    :email,
    :role,
    :nurse_type,
    :sex,
    :phone,
    :address,
    :languages,
    :pref_commute_distance,
    :occupation,
    :speciality,
    :experience,
    :accept_terms,
    :active,
    :image_url,
    :sort_code,
    :bank_account,
    :verified,
    :postcode
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :hospital,
    :first_name,
    :last_name,
    :email,
    :role,
    :nurse_type,
    :sex,
    :phone,
    :address,
    :languages,
    :pref_commute_distance,
    :occupation,
    :speciality,
    :experience,
    :accept_terms,
    :active,
    :image_url,
    :sort_code,
    :bank_account,
    :verified,
    :postcode
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
end
