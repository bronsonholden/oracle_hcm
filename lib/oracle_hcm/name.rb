require "oracle_hcm/resource"

module OracleHcm
  class Name < Resource
    property :first_name, key: "FirstName"
    property :last_name, key: "LastName"
    property :previous_last_name, key: "PreviousLastName"
  end
end
