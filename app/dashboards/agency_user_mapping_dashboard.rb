require "administrate/base_dashboard"

class AgencyUserMappingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    agency: Field::BelongsTo,
    user: Field::BelongsTo,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    verified: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :agency,
    :user,
    :verified,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :agency,
    :user,
    :id,
    :created_at,
    :updated_at,
    :verified,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :verified,
  ].freeze

  # Overwrite this method to customize how agency user mappings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(agency_user_mapping)
  #   "AgencyUserMapping ##{agency_user_mapping.id}"
  # end
end
