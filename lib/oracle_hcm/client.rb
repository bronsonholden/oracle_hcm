require "faraday"
require "json"
require "oracle_hcm/resource_list"
require "oracle_hcm/worker"
require "oracle_hcm/document_record"

module OracleHcm
  class Client
    attr_reader :endpoint, :username, :password

    def initialize(endpoint, username, password)
      @endpoint = endpoint
      @username = username
      @password = password
    end

    # Sugar syntax for defining top-level resources
    def self.resource(method, resource:, url: resource.resource_name)
      define_method(method) do |offset: 0, limit: 20, q: []|
        if !q.is_a?(Array)
          q = [q]
        end
        res = connection.get do |req|
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

    # Retrieve worker resources.
    resource :workers, resource: Worker
    resource :document_records, resource: DocumentRecord

    # Retrieve a single worker resource by PersonId
    def worker(id:)
      workers(q: "PersonId=#{id}").items.first
    end

    # Retrieve a single document record resource by DocumentsOfRecordId
    def document_record(id:)
      document_records(q: "DocumentsOfRecordId=#{id}").items.first
    end

    # Get an authenticated Faraday connection using given credentials.
    def connection
      url = "#{endpoint}/hcmRestApi/resources/11.13.18.05"
      Faraday.new(url: url) do |conn|
        conn.basic_auth(username, password)
      end
    end
  end
end
