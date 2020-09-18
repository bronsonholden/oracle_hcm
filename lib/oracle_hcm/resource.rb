module OracleHcm
  # Base class for all resources in Oracle HCM. Provides some sugar syntax
  # and shared methods.
  class Resource
    attr_reader :data, :client, :parent

    def initialize(data, client, parent = nil)
      @data = data
      @client = client
      @parent = parent
      @cache = {}
    end

    # Sugar syntax for defining methods that return data at given keys in
    # the resource JSON. Properties are not a 1:1 match with data in the
    # object JSON. They can be wrappers for sending requests to related
    # resources such as names or addresses, although those are better defined
    # as cached properties.
    def self.property(name, key: nil, &block)
      define_method(name) {
        if block_given?
          yield
        else
          data.fetch(key)
        end
      }
    end

    # Sugar syntax for defining properties that are cached to avoid making
    # multiple requests for data that is not expected to change during
    # execution, such as employee names or SSNs. Also defines a bang method
    # that will skip and overwrite the cache.
    def self.cached_property(name, &block)
      bang = :"#{name.to_s}!"
      define_method(bang) {
        instance_variable_get(:@cache)[name] = instance_eval(&block)
      }
      define_method(name) {
        @cache[name] || self.send(bang)
      }
    end

    def resource_url
      parts = [
        resource_name,
        canonical_id
      ]

      if !parent.nil?
        parts = [parent.resource_url, 'child'].concat(parts)
      end

      parts.reject(&:nil?).join("/")
    end

    # Sugar syntax for defining child resource retrieval methods
    def self.child_resource(method, resource:)
      define_method(method) do |offset: 0, limit: 20, q: []|
        # Generate the URL for the request
        url = "#{resource_url}/child/#{resource.resource_name}"
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
          ResourceList.new(JSON.parse(res.body), offset, limit, method, resource, client, self)
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
    # in the URL to retrieve some resources. Instead, a longer identifier
    # string is used. This identifier is only displayed as part of the self
    # link for the resource.
    def canonical_id
      # Extract resource identifier from self link
      m = link.fetch("href").match(/\/([0-9A-F]+)\z/)
      m[1]
    end

    def uri(rel: "self")
      link(rel: rel).fetch("href").gsub(client.base_url, "")
    end
  end
end
