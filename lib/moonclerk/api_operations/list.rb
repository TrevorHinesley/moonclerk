module Moonclerk
  module APIOperations
    module List
      def list(params = {})
        response = request(:get, url, params)

        klass = self.is_a?(Moonclerk::ListObject) ? self[:object] : self.class_name.underscore.downcase
        obj = ListObject.construct_from({ data: response, object: klass })
        
        # Set a count and offset so that we can fetch the same number when accessing the
        # next and previous pages
        obj.count = params[:count]
        obj.offset = params[:offset]

        obj
      end

      # This method returns a page of objects, so #all
      # is not an appropriate method name, but it is
      # aliased for convenience.
      alias :all :list

      def where(options = {})
        options = Util.symbolize_names(options)
        params = {}
        (@permitted_attributes + default_param_keys).each do |key|
          if options[key]
            if key.to_s.split("_").last =~ /from|to/
              params[key] = CGI.escape(options[key].strftime("%Y-%m-%d"))
            else
              params[key] = CGI.escape(options[key].to_s)
            end
          end
        end

        list(params)
      end
    end
  end
end