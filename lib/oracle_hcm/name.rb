require "oracle_hcm/resource"

module OracleHcm
  # A Name is a child resource of a Worker that stores various data about a
  # Worker's name(s).
  class Name < Resource
    property :first_name, key: "FirstName"
    property :last_name, key: "LastName"
    property :previous_last_name, key: "PreviousLastName"
  end
end
