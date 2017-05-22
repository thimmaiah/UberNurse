ThinkingSphinx::Index.define :staffing_request, :with => :real_time do
  # fields
  indexes care_home.name, :as => :care_home_name, :sortable => true
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true

  indexes broadcast_status
  indexes payment_status
  indexes start_code
  indexes end_code
    
  # attributes
  has care_home_id,  :type => :integer
  has user_id,  :type => :integer
  has request_status, :type=>:string
end

ThinkingSphinx::Index.define :care_home, :with => :real_time do
  # fields
  indexes name
  indexes address
  indexes street
  indexes postcode
  indexes town

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


ThinkingSphinx::Index.define :rating, :with => :real_time do
  # fields
  indexes comments
  indexes care_home.name, :as => :care_home_name, :sortable => true
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true

  has user_id,  :type => :integer
  has care_home_id,  :type => :integer
  has stars,  :type => :integer
end

ThinkingSphinx::Index.define :payment, :with => :real_time do
  # fields
  indexes care_home.name, :as => :care_home_name, :sortable => true
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true
  indexes notes

  has user_id,  :type => :integer
  has care_home_id,  :type => :integer
  has amount,  :type => :float
end


ThinkingSphinx::Index.define :user_doc, :with => :real_time do
  # fields
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true
  indexes :name  
  indexes doc_type

  has user_id,  :type => :integer
end


ThinkingSphinx::Index.define :staffing_response, :with => :real_time do
  # fields
  indexes care_home.name, :as => :care_home_name, :sortable => true
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true  

  indexes start_code
  indexes end_code 
  indexes response_status
  indexes payment_status
  
  has user_id,  :type => :integer
  has care_home_id,  :type => :integer
  has rated,  :type => :boolean
  has accepted,  :type => :boolean
end