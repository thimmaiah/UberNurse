ThinkingSphinx::Index.define :staffing_request, :with => :real_time do
  # fields
  indexes care_home.name, :as => :care_home_name, :sortable => true
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true

  # attributes
  has care_home_id,  :type => :integer
  has user_id,  :type => :integer
  has request_status, :type=>:string
  has broadcast_status, :type=>:string
  has shift_status, :type=>:string
end

ThinkingSphinx::Index.define :care_home, :with => :real_time do
  # fields
  indexes name
  has zone, :type=>:string
  has verified, :type=>:boolean
end

ThinkingSphinx::Index.define :referral, :with => :real_time do
  # fields
  indexes first_name
  indexes last_name
  indexes email
  has referral_status, :type=>:string
  has payment_status, :type=>:string
end

ThinkingSphinx::Index.define :post_code, :with => :real_time do
  # fields
  indexes postcode
  indexes postcode_wo_spaces
end


ThinkingSphinx::Index.define :cqc_record, :with => :real_time do
  # fields

  indexes name
  indexes aka
  indexes address
  indexes phone
  indexes service_types
  indexes services
  indexes local_authority
  indexes region
  indexes cqc_location

  has postcode, :type=>:string

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
  has phone_verified, :type=>:boolean
  has active, :type=>:boolean
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


ThinkingSphinx::Index.define :shift, :with => :real_time do
  # fields
  indexes care_home.name, :as => :care_home_name, :sortable => true
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true  

  
  has user_id,  :type => :integer
  has care_home_id,  :type => :integer
  has rated,  :type => :boolean
  has accepted,  :type => :boolean
  has response_status, :type => :string
  has payment_status, :type => :string
  has care_home_payment_status, :type => :string
  has start_code, :type => :string
  has end_code, :type => :string
end