require "oracle_hcm/resource"

module OracleHcm
  # A ResourceList is a helper object that makes it easy to poll through
  # paginated resources.
  class ResourceList < Resource
    attr_reader :limit, :offset, :method, :resource, :client, :parent

    def initialize(data, offset, limit, method, resource, client, parent = nil)
      super(data, client)
      @limit = limit
      @offset = offset
      @method = method
      @resource = resource
      @parent = parent
    end

    def next
      client.send(method, limit: limit, offset: offset + limit)
    end

    def items
      @data.fetch("items").map { |item|
        resource.new(item, client, parent)
      }
    end
  end
end
