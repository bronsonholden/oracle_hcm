require "oracle_hcm/resource"

module OracleHcm
  # A NationalIdentifier is a child resource of a Worker that stores various
  # uniquely identifying information about a Worker, such as their SSN.
  class NationalIdentifier < Resource
    property :national_identifier_type, key: "NationalIdentifierType"
    property :national_identifier_number, key: "NationalIdentifierNumber"
    property :primary_flag, key: "PrimaryFlag"
  end
end
