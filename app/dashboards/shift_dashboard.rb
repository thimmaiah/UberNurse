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
    carer_base: Field::Number.with_options(decimals: 2),
    care_home_total_amount: Field::Number.with_options(decimals: 2),
    care_home_base: Field::Number.with_options(decimals: 2),
    markup: Field::Number.with_options(decimals: 2),
    vat: Field::Number.with_options(decimals: 2),
    rating: Field::HasOne,
    id: Field::Number,
    manual_close: Field::Boolean,
    preferred_care_giver_selected: Field::Boolean, 
    start_code: Field::String,
    end_code: Field::String,
    start_date: Field::DateTime,
    end_date: Field::DateTime,
    response_status: Field::Select.with_options(collection: Shift::RESPONSE_STATUS),
    accepted: Field::Boolean,
    rated: Field::Boolean,
    pricing_audit: HashField, 
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
    :start_date,
    :end_date,
    :response_status,
    :manual_close,
    :preferred_care_giver_selected,
    :rated,
    :care_home_total_amount
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :staffing_request,
    :care_home,
    :payment,
    :care_home_base,
    :vat,
    :care_home_total_amount,
    :markup,
    :carer_base,        
    :rating,
    :id,
    :manual_close,
    :preferred_care_giver_selected,
    :start_code,
    :end_code,
    :start_date,
    :end_date,
    :response_status,
    :pricing_audit,
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
    :start_date,
    :end_date,
    :start_code,
    :end_code,
    :manual_close,
  ].freeze

  # Overwrite this method to customize how staffing responses are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(shift)
  #   "Shift ##{shift.id}"
  # end
end
