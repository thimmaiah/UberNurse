require "administrate/base_dashboard"

class StaffingRequestDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    hospital: Field::BelongsTo,
    user: Field::BelongsTo,
    staffing_responses: Field::HasMany,
    payment: Field::HasOne,
    id: Field::Number,
    start_date: Field::DateTime,
    end_date: Field::DateTime,
    rate_per_hour: Field::Number.with_options(decimals: 2),
    request_status: Field::String,
    auto_deny_in: Field::Number.with_options(decimals: 2),
    response_count: Field::Number,
    payment_status: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    start_code: Field::String,
    end_code: Field::String,
    broadcast_status: Field::String,
    versions: VersionField
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :hospital,
    :user,
    :staffing_responses,
    :payment
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :hospital,
    :user,
    :staffing_responses,
    :payment,
    :id,
    :start_date,
    :end_date,
    :rate_per_hour,
    :request_status,
    :auto_deny_in,
    :response_count,
    :payment_status,
    :created_at,
    :updated_at,
    :start_code,
    :end_code,
    :broadcast_status,
    :versions
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :hospital,
    :user,
    :staffing_responses,
    :payment,
    :start_date,
    :end_date,
    :rate_per_hour,
    :request_status,
    :auto_deny_in,
    :response_count,
    :payment_status,
    :start_code,
    :end_code,
    :broadcast_status,
  ].freeze

  # Overwrite this method to customize how staffing requests are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(staffing_request)
  #   "StaffingRequest ##{staffing_request.id}"
  # end
end
