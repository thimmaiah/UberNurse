require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    care_home: Field::BelongsTo,
    user_docs: Field::HasMany,
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    email: Field::String,
    role: Field::Select.with_options(collection: User::ROLE),
    nurse_type: Field::String,
    sex: Field::Select.with_options(collection: User::SEX),
    phone: Field::String,
    address: Field::Text,
    languages: Field::String,
    pref_commute_distance: Field::Number,
    occupation: Field::String,
    speciality: Field::Select.with_options(collection: User::SPECIALITY),
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
    :id,
    :care_home,
    :first_name,
    :last_name,
    :email,
    :verified,
    :role
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :care_home,
    :id,
    :first_name,
    :last_name,
    :email,
    :role,
    :sex,
    :phone,
    :languages,
    :pref_commute_distance,
    :speciality,
    :experience,
    :image_url,
    :sort_code,
    :bank_account,
    :verified,
    :active,
    :postcode,
    :user_docs
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :care_home,
    :first_name,
    :last_name,
    :email,
    :role,
    :sex,
    :phone,
    :languages,
    :pref_commute_distance,
    :speciality,
    :experience,
    :image_url,
    :sort_code,
    :bank_account,
    :verified,
    :active,
    :postcode
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    "#{user.first_name} #{user.last_name} #{user.id}"
  end
end
