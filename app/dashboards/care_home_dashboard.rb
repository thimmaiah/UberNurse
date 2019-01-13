require "administrate/base_dashboard"

class CareHomeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    zone: Field::Select.with_options(collection: CareHome::ZONES),
    users: Field::HasMany,
    staffing_requests: Field::HasMany.with_options(limit: 10, sort_by: :start_date),
    name: Field::String,
    speciality: Field::Select.with_options(collection: User::SPECIALITY),
    phone: Field::String,
    address: Field::String.with_options(required: true),
    town: Field::String.with_options(required: true),
    postcode: Field::String.with_options(required: true),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    image_url: Field::Text,
    sister_care_homes: Field::String,
    qr_code: QrCodeField,
    lat: Field::String.with_options(searchable: false),
    lng: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :speciality,
    :sister_care_homes,
    :town,
    :zone
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :qr_code,
    :speciality,
    :phone,
    :zone,
    :sister_care_homes,
    :address,
    :town,
    :postcode,
    :created_at,
    :updated_at,
    :image_url,
    :lat,
    :lng,
    :users,
    :staffing_requests,

  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :speciality,
    :phone,
    :sister_care_homes,
    :address,
    :town,
    :postcode,
    :image_url,
    :zone,
    :qr_code,
  ].freeze

  # Overwrite this method to customize how care_homes are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(care_home)
    "#{care_home.name} #{care_home.id}"
  end
end
