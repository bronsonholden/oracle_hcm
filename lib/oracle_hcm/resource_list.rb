require "oracle_hcm/resource"

module OracleHcm
  class ResourceList < Resource
    attr_reader :limit, :offset, :method, :resource

    def initialize(data, offset, limit, method, resource, client)
      super(data, client)
      @limit = limit
      @offset = offset
      @method = method
      @resource = resource
    end

    def next
      client.send(method, limit: limit, offset: offset + limit)
    end

    def items
      @data.fetch("items").map { |item|
        resource.new(item, client)
      }
    end
  end
end
