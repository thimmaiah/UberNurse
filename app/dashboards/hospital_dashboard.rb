require "administrate/base_dashboard"

class HospitalDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    users: Field::HasMany,
    staffing_requests: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    address: Field::String,
    street: Field::String,
    locality: Field::String,
    town: Field::String,
    postcode: Field::String,
    base_rate: Field::Number.with_options(decimals: 2),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    image_url: Field::Text,
    lat: Field::String.with_options(searchable: false),
    lng: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :users,
    :staffing_requests,
    :id,
    :name,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :users,
    :staffing_requests,
    :id,
    :name,
    :address,
    :street,
    :locality,
    :town,
    :postcode,
    :base_rate,
    :created_at,
    :updated_at,
    :image_url,
    :lat,
    :lng,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :users,
    :staffing_requests,
    :name,
    :address,
    :street,
    :locality,
    :town,
    :postcode,
    :base_rate,
    :image_url,
    :lat,
    :lng,
  ].freeze

  # Overwrite this method to customize how hospitals are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(hospital)
  #   "Hospital ##{hospital.id}"
  # end
end
