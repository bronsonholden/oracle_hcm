require "oracle_hcm/resource"

module OracleHcm
  class Name < Resource
    property :first_name, key: "FirstName"
    property :last_name, key: "LastName"
  end
end
