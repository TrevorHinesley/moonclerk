module Moonclerk
  class ListObject < APIResource
    include Enumerable
    include Moonclerk::APIOperations::List

    # This accessor allows a `ListObject` to inherit a count that was given to
    # a predecessor. This allows consistent counts as a user pages through
    # resources. Offset is used to shift the starting point of the list.
    attr_accessor :count, :offset

    # An empty list object. This is returned from +next+ when we know that
    # there isn't a next page in order to replicate the behavior of the API
    # when it attempts to return a page beyond the last.
    def self.empty_list
      ListObject.construct_from({ data: [], object: "" })
    end

    def [](k)
      case k
      when String, Symbol
        super
      else
        raise ArgumentError.new("You tried to access the #{k.inspect} index, but ListObject types only support String keys.")
      end
    end

    # Iterates through each resource in the page represented by the current
    # `ListObject`.
    #
    # Note that this method makes no effort to fetch a new page when it gets to
    # the end of the current page's resources. See also +auto_paging_each+.
    def each(&blk)
      self.data.each(&blk)
    end

    # Iterates through each resource in all pages, making additional fetches to
    # the API as necessary.
    #
    # Note that this method will make as many API calls as necessary to fetch
    # all resources. For more granular control, please see +each+ and
    # +next_page+.
    def auto_paging_each(&blk)
      return enum_for(:auto_paging_each) unless block_given?

      page = self
      loop do
        page.each(&blk)
        page = page.next_page
        break if page.empty?
      end
    end

    # Returns true if the page object contains no elements.
    def empty?
      self.data.blank?
    end

    def retrieve(id)
      id, retrieve_params = Util.normalize_id(id)
      response = request(:get,"#{url}/#{CGI.escape(id)}", retrieve_params)
      Util.convert_to_moonclerk_object(response)
    end

    def create(params = {})
      response = request(:post, url, params)
      Util.convert_to_moonclerk_object(response)
    end

    # Fetches the next page in the resource list (if there is one).
    #
    # This method will try to respect the count of the current page. If none
    # was given, the default count will be fetched again.
    def next_page(params = {})
      params = {
        :count          => count, # may be nil
        :offset         => (offset || 0) + (count || 20),
      }.merge(params)

      list(params)
    end

    # Fetches the previous page in the resource list (if there is one).
    #
    # This method will try to respect the count of the current page. If none
    # was given, the default count will be fetched again.
    def previous_page(params = {})
      new_offset = (offset || 0) - (count || 20)
      new_offset = 0 if new_offset < 0

      params = {
        :count         => count, # may be nil
        :offset        => new_offset,
      }.merge(params)

      list(params)
    end
  end
end