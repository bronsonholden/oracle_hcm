module OracleHcm
  class Resource
    attr_reader :data, :client

    def initialize(data, client)
      @data = data
      @client = client
    end

    # Sugar syntax for defining methods that return data at given keys in
    # the resource JSON.
    def self.property(name, key: nil, &block)
      define_method(name) {
        if block_given?
          yield
        else
          data.fetch(key)
        end
      }
    end

    # Sugar syntax for defining child resource retrieval methods
    def self.child_resource(method, resource:)
      define_method(method) do |offset: 0, limit: 20, q: []|
        # Generate the URL for the request
        url = "#{resource_name}/#{canonical_id}/child/#{resource.resource_name}"
        if !q.is_a?(Array)
          q = [q]
        end
        res = client.connection.get do |req|
          req.url url
          req.params["offset"] = offset
          req.params["limit"] = limit
          if q.any?
            req.params["q"] = q.join(";")
          end
        end
        if res.success?
          ResourceList.new(JSON.parse(res.body), offset, limit, method, resource, self)
        else
          nil
        end
      end
    end

    def self.resource_name
      name = self.to_s.split("::").last
      "#{name[0].downcase}#{name[1..-1]}s"
    end

    def resource_name
      self.class.resource_name
    end

    # Retrieve a link by its relationship. By default, returns the self link.
    def link(rel: "self")
      data.fetch("links").select { |link|
        link.fetch("rel") == rel
      }.first
    end

    # Although resources have unique identifiers, the API does not use these
    # in the URL to retrieve a resource. Instead, a longer identifier string
    # is used. This identifier is only displayed as part of the self link
    # for the resource.
    def canonical_id
      # Extract resource identifier from self link
      m = link.fetch("href").match(/\/([0-9A-F]+)\z/)
      m[1]
    end
  end
end
