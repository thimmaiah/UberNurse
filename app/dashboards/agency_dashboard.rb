require "administrate/base_dashboard"

class AgencyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    agency_user_mappings: Field::HasMany,
    agency_care_home_mappings: Field::HasMany,
    users: Field::HasMany,
    care_homes: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    broadcast_group: Field::String,
    address: Field::String,
    postcode: Field::String,
    phone: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :agency_user_mappings,
    :agency_care_home_mappings,
    :users,
    :care_homes,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :agency_user_mappings,
    :agency_care_home_mappings,
    :users,
    :care_homes,
    :id,
    :name,
    :broadcast_group,
    :address,
    :postcode,
    :phone,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :agency_user_mappings,
    :agency_care_home_mappings,
    :users,
    :care_homes,
    :name,
    :broadcast_group,
    :address,
    :postcode,
    :phone,
  ].freeze

  # Overwrite this method to customize how agencies are displayed
  # across all pages of the admin dashboard.
  
  def display_resource(agency)
    "Agency #{agency.name}: #{agency.id}"
  end
end
