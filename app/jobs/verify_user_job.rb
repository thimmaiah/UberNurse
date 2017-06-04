class VerifyUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
  	# The user whose docs have been uploaded
    user = User.find(user_id)
    #Assume he is verified
    verified = true
    doc_count = 0
    # For each of the required docs - check if the doc is verified
    # The docs must not have expired or prev rejected
    user_docs = user.verifiable_docs
    user_docs.each do |doc|
    	if( UserDoc::DOC_TYPES.include?(doc.doc_type) )
    		logger.debug("Verifying user #{user.id} doc #{doc.id} - #{doc.verified}")
    		verified = verified && doc.verified
    		doc_count += 1
    	end
    end

    # Did we have all the required docs?
    if(doc_count < UserDoc::DOC_TYPES.length)
    	verified = false
    end

    # Save the verified status
    logger.debug("Verifying user #{user.id} setting verified to #{verified}")
    user.verified = verified
    user.save


  end
end
