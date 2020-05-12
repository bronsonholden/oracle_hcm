require "oracle_hcm/resource"
require "oracle_hcm/name"
require "oracle_hcm/national_identifier"
require "oracle_hcm/document_record"

module OracleHcm
  class Worker < Resource
    child_resource :names, resource: Name
    child_resource :national_identifiers, resource: NationalIdentifier
    property :person_id, key: "PersonId"
    cached_property :first_name do names.items.first.first_name; end
    cached_property :last_name do names.items.first.last_name; end

    def ssns
      national_identifiers q: "NationalIdentifierType=SSN"
    end
  end
end
