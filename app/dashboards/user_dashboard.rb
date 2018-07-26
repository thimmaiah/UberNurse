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
    shifts: Field::HasMany,
    versions: VersionField,
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
    ready_for_verification: Field::Boolean,
    phone_verified: Field::Boolean,
    postcode: Field::String,
    created_at: Field::DateTime,
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
    :ready_for_verification,
    :phone_verified,
    :role,
    :pref_commute_distance,
    :created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user_docs,    
    :verified,
    :ready_for_verification,
    :phone_verified,
    :id,
    :first_name,
    :last_name,
    :email,
    :role,
    :sex,
    :phone,
    :pref_commute_distance,
    :sort_code,
    :bank_account,
    :active,
    :postcode,
    :care_home,
    :shifts,
    :versions

  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :verified,
    :phone_verified,
    :first_name,
    :last_name,
    :email,
    :role,
    :sex,
    :phone,
    :pref_commute_distance,
    :image_url,
    :sort_code,
    :bank_account,
    :active,
    :postcode,
    :created_at
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    "#{user.first_name} #{user.last_name} #{user.id}"
  end
end
