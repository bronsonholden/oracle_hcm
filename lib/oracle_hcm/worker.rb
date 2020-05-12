require "oracle_hcm/resource"
require "oracle_hcm/name"
require "oracle_hcm/national_identifier"
require "oracle_hcm/document_record"

module OracleHcm
  class Worker < Resource
    property :person_id, key: "PersonId"

    child_resource :national_identifiers, resource: NationalIdentifier

    def ssns
      national_identifiers q: "NationalIdentifierType=SSN"
    end
  end
end
