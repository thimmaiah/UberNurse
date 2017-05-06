ThinkingSphinx::Index.define :staffing_request, :with => :real_time do
  # fields
  indexes hospital.name, :as => :hospital_name, :sortable => true

  # attributes
  has hospital_id,  :type => :integer
  has user_id,  :type => :integer
  has request_status, :type=>:string
end


ThinkingSphinx::Index.define :user, :with => :real_time do
  # fields
  indexes first_name
  indexes last_name
  indexes postcode
  indexes speciality

  # attributes
  has lat, :as => :latitude,  :type => :float 
  has lng, :as => :longitude,  :type => :float
  has verified, :type=>:boolean
  has role, :type=>:string
  has auto_selected_date, :type => :timestamp
end