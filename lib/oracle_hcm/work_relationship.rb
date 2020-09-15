require "oracle_hcm/resource"

module OracleHcm
  # A WorkRelationship is a child resource of a Worker that stores data
  # about their employment status regarding the organization
  class WorkRelationship < Resource
    property :legal_entity_id, key: "LegalEntityId"
    property :legal_employer_name, key: "LegalEmployerName"
    property :start_date, key: "StartDate"
    property :termination_date, key: "TerminationDate"
    property :recommended_for_rehire, key: "RecommendedForRehire"
  end
end
