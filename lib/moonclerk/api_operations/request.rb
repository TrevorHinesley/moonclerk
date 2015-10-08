module Moonclerk
  module APIOperations
    module Request
      module ClassMethods

        def request(method, url, params = {})
          Moonclerk.request(method, url, params)
        end

        def default_param_keys
          Moonclerk.default_param_keys
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      protected

      def request(method, url, params = {})
        self.class.request(method, url, params)
      end

      def default_param_keys
        self.class.default_param_keys
      end
    end
  end
end