require "administrate/base_dashboard"

class UserDocDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    user_id: Field::Number,
    name: Field::String,
    doc_type: Field::Select.with_options(collection: UserDoc::DOC_TYPES),
    user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    doc_file_name: Field::String,
    doc_content_type: Field::String,
    doc_file_size: Field::Number,
    doc_updated_at: Field::DateTime,
    verified: Field::Boolean,
    notes: Field::Text,
    doc: PaperclipField
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :doc_type,
    :user,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :doc_type,
    :user,
    :created_at,
    :updated_at,
    :doc_file_name,
    :verified,
    :notes,
    :doc
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :user_id,
    :doc_type,
    :doc_file_name,
    :verified,
    :notes,
    :doc
  ].freeze

  # Overwrite this method to customize how user docs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user_doc)
  #   "UserDoc ##{user_doc.id}"
  # end
end
