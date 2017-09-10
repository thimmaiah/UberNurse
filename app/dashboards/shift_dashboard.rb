require "administrate/base_dashboard"

class ShiftDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    staffing_request: Field::BelongsTo,
    care_home: Field::BelongsTo,
    payment: Field::HasOne,
    rating: Field::HasOne,
    id: Field::Number,
    start_code: Field::String,
    end_code: Field::String,
    response_status: Field::Select.with_options(collection: Shift::RESPONSE_STATUS),
    accepted: Field::Boolean,
    rated: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    payment_status: Field::Select.with_options(collection: Shift::PAYMENT_STATUS),
    care_home_payment_status: Field::Select.with_options(collection: Shift::PAYMENT_STATUS),
    versions: VersionField
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :user,
    :care_home,
    :response_status,
    :payment_status,
    :care_home_payment_status,
    :rated,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :staffing_request,
    :care_home,
    :payment,
    :rating,
    :id,
    :start_code,
    :end_code,
    :response_status,
    :accepted,
    :rated,
    :created_at,
    :updated_at,
    :payment_status,
    :care_home_payment_status,
    :versions
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :start_code,
    :end_code,
    :response_status,
    :payment_status,
    :care_home_payment_status
  ].freeze

  # Overwrite this method to customize how staffing responses are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(shift)
  #   "Shift ##{shift.id}"
  # end
end
