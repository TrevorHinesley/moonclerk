module Moonclerk
  module Util
    def self.object_classes
      @object_classes ||= {
        'customer' => Customer,
        'form' => Form,
        'payment' => Payment
      }
    end

    def self.convert_to_moonclerk_object(resp, class_name = nil)
      case resp
      when Array
        resp.map { |i| convert_to_moonclerk_object(i, class_name) }
      when Hash
        # Try converting to a known object class.  If none available, fall back to generic MoonclerkObject
        object_classes.fetch(class_name, MoonclerkObject).construct_from(resp)
      else
        resp
      end
    end

    def self.normalize_id(id)
      if id.kind_of?(Hash) # overloaded id
        params_hash = id.dup
        id = params_hash.delete(:id)
      else
        params_hash = {}
      end
      [id, params_hash]
    end

    def self.symbolize_names(object)
      case object
      when Hash
        new_hash = {}
        object.each do |key, value|
          key = (key.to_sym rescue key) || key
          new_hash[key] = symbolize_names(value)
        end
        new_hash
      when Array
        object.map { |value| symbolize_names(value) }
      else
        object
      end
    end
  end
end