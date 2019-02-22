require "administrate/base_dashboard"

class AgencyCareHomeMappingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    agency: Field::BelongsTo,
    care_home: Field::BelongsTo,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    verified: Field::Boolean,
    accepted: Field::Boolean,
    notes: Field::Text,
    manual_assignment_flag: Field::Boolean,
    preferred_care_giver_ids: Field::String,
    limit_shift_to_pref_carer: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :agency,
    :care_home,
    :verified,
    :accepted,
    :preferred_care_giver_ids,
    :manual_assignment_flag,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :agency,    
    :care_home,
    :id,
    :created_at,
    :updated_at,
    :verified,
    :accepted,
    :manual_assignment_flag,
    :preferred_care_giver_ids,
    :limit_shift_to_pref_carer,
    :notes,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :verified,
    :manual_assignment_flag,
    :preferred_care_giver_ids,
    :limit_shift_to_pref_carer,
    :notes,
  ].freeze

  # Overwrite this method to customize how agency care home mappings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(agency_care_home_mapping)
  #   "AgencyCareHomeMapping ##{agency_care_home_mapping.id}"
  # end
end
