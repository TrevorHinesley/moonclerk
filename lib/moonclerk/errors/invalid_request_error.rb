module Moonclerk
  class InvalidRequestError < MoonclerkError
    attr_accessor :param

    def initialize(message, http_status=nil, http_body=nil, json_body=nil,
                   http_headers=nil)
      super(message, http_status, http_body, json_body, http_headers)
    end
  end
end