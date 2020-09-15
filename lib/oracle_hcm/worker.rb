require "oracle_hcm/resource"
require "oracle_hcm/name"
require "oracle_hcm/national_identifier"
require "oracle_hcm/document_record"
require "oracle_hcm/work_relationship"

module OracleHcm
  # A Worker is a resources that represents an employee within the system.
  class Worker < Resource
    child_resource :names, resource: Name
    child_resource :national_identifiers, resource: NationalIdentifier
    child_resource :work_relationships, resource: WorkRelationship
    property :person_id, key: "PersonId"
    property :person_number, key: "PersonNumber"
    cached_property :first_name do names.items.first.first_name; end
    cached_property :last_name do names.items.first.last_name; end

    def ssns
      national_identifiers q: "NationalIdentifierType=SSN"
    end
  end
end
