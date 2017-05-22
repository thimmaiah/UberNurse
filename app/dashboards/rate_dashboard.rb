require "administrate/base_dashboard"

class RateDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    zone: Field::Select.with_options(collection: CareHome::ZONES),
    role: Field::Select.with_options(collection: User::ROLE),
    speciality: Field::Select.with_options(collection: User::SPECIALITY),
    amount: Field::Number.with_options(decimals: 2),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :zone,
    :role,
    :speciality,
    :amount,
    
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :zone,
    :role,
    :speciality,
    :amount,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :zone,
    :role,
    :speciality,
    :amount,
  ].freeze

  # Overwrite this method to customize how rates are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(rate)
     "#{rate.zone}-#{rate.role}-#{rate.speciality}-#{rate.amount}"
  end
end
