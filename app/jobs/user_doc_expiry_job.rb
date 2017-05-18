class UserDocExpiryJob < ApplicationJob
  queue_as :default

  def perform()

    cert_expiry = Date.today - eval(ENV["CERTIFICATE_EXPIRY"])
    id_expiry = Date.today - eval(ENV["ID_CARD_EXPIRY"])
    address_expiry = Date.today - eval(ENV["ADDRESS_PROOF_EXPIRY"])
    dbx_expiry = Date.today - eval(ENV["DBS_EXPIRY"])

    # Ensure all doc types are expired based on settings in .env
    UserDoc.certificates.where("created_at < ?", cert_expiry).update_all(expired: true)
    UserDoc.id_cards.where("created_at < ?", id_expiry).update_all(expired: true)
    UserDoc.address_proofs.where("created_at < ?", address_expiry).update_all(expired: true)
    UserDoc.dbs.where("created_at < ?", dbx_expiry).update_all(expired: true)
  end
end
