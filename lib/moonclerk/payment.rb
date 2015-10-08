module Moonclerk
  class Payment < APIResource
    extend Moonclerk::APIOperations::List
    @permitted_attributes = [:form_id,
                             :customer_id,
                             :date_from, 
                             :date_to, 
                             :status]
  end
end