module Moonclerk
  class APIResource < MoonclerkObject
    include Moonclerk::APIOperations::Request

    def self.class_name
      self.name.split('::')[-1]
    end

    def self.url
      if self == APIResource
        raise NotImplementedError.new('APIResource is an abstract class.  You should perform actions on its subclasses (Customer, Payment, etc.)')
      end
      "#{API_BASE}/#{CGI.escape(class_name.downcase)}s"
    end

    def url
      if self.is_a?(Moonclerk::ListObject)
        return "#{API_BASE}/#{CGI.escape(self[:object])}s"
      end

      unless id = self['id']
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.url}/#{CGI.escape(id)}"
    end

    def refresh
      response = request(:get, url, @retrieve_params)
      refresh_from(response)
    end

    def self.retrieve(id)
      instance = self.new(id.to_s)
      instance.refresh
      instance
    end

    def self.find(id)
      self.retrieve(id)
    end
  end
end