require "oracle_hcm/resource"

module OracleHcm
  class NationalIdentifier < Resource
    property :national_identifier_type, key: "NationalIdentifierType"
    property :national_identifier_number, key: "NationalIdentifierNumber"
  end
end
