ThinkingSphinx::Index.define :staffing_request, :with => :real_time do
  # fields
  indexes hospital.name, :as => :hospital_name, :sortable => true

  # attributes
  has hospital_id,  :type => :integer
  has user_id,  :type => :integer
  has created_at, :type => :timestamp
  has updated_at, :type => :timestamp
end