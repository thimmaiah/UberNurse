require "administrate/base_dashboard"

class RecurringRequestDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    care_home: BelongsToOrderedField,
    staffing_requests: Field::HasMany,
    user: Field::BelongsTo,
    user_id: Field::Number,
    preferred_carer_id: Field::Number,
    id: Field::Number,
    start_date: Field::DateTime,
    end_date: Field::DateTime,
    role: Field::Select.with_options(collection: User::ROLE), 
    speciality: Field::Select.with_options(collection: User::SPECIALITY),    
    on: Field::String,
    start_on: Field::DateTime,
    end_on: Field::DateTime,
    audit: HashField,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    next_generation_date: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :care_home,
    :user,
    :role,
    :speciality,
    :start_on,
    :end_on,
    :on,
    :next_generation_date
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :care_home,
    :user,
    :id,
    :start_date,
    :end_date,
    :role,
    :speciality,
    :on,
    :start_on,
    :end_on,    
    :created_at,
    :updated_at,
    :next_generation_date,
    :staffing_requests,
    :audit
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :care_home,
    :user_id,
    :start_date,
    :end_date,
    :role,
    :speciality,
    :on,
    :end_on,
  ].freeze

  # Overwrite this method to customize how recurring requests are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(recurring_request)
  #   "RecurringRequest ##{recurring_request.id}"
  # end
end
