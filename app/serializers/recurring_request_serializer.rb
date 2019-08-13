class RecurringRequestSerializer < ActiveModel::Serializer
  attributes :id, :care_home_id, :user_id, :start_date, :end_date, :role, :speciality, :agency, :care_home, :user, :dates, :created_at

  belongs_to :user, serializer: UserMiniSerializer
  belongs_to :agency, serializer: AgencySerializer
  belongs_to :care_home, serializer: CareHomeMiniSerializer
end
