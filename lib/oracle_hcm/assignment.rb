require "oracle_hcm/resource"

module OracleHcm
  class Assignment < Resource
    property :business_unit_id, key: "BusinessUnitId"
    property :business_unit, key: "BusinessUnitName"
    property :assignment_status, key: "AssignmentStatusType"
    property :primary?, key: "PrimaryFlag"
    property :job_code, key: "JobCode"
  end
end
