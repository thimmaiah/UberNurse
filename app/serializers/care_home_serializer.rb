class CareHomeSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :town, :postcode, :base_rate, :phone,
    :can_manage, :image_url, :verified, :bank_account, :sort_code,
    :accept_bank_transactions, :accept_bank_transactions_date, :qr_code
    
  def can_manage
    Ability.new(scope).can?(:manage, object)
  end
end
