require "administrate/base_dashboard"

class RatingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    staffing_response: Field::BelongsTo,
    user: Field::BelongsTo,
    hospital: Field::BelongsTo,
    created_by: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    stars: Field::Number,
    comments: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    created_by_id: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :staffing_response,
    :user,
    :hospital,
    :created_by,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :staffing_response,
    :user,
    :hospital,
    :created_by,
    :id,
    :stars,
    :comments,
    :created_at,
    :updated_at,
    :created_by_id,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :staffing_response,
    :user,
    :hospital,
    :created_by,
    :stars,
    :comments,
    :created_by_id,
  ].freeze

  # Overwrite this method to customize how ratings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(rating)
  #   "Rating ##{rating.id}"
  # end
end
