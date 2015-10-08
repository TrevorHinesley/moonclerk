module Moonclerk
  class Customer < APIResource
    extend Moonclerk::APIOperations::List
    @permitted_attributes = [:form_id,
                             :checkout_from, 
                             :checkout_to, 
                             :next_payment_from, 
                             :next_payment_to, 
                             :status]
  end
end