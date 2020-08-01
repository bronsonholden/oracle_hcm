require "oracle_hcm/resource"
require "oracle_hcm/attachment"

module OracleHcm
  # A DocumentRecord is a resource that represents a record of document(s)
  # of a given category for a Worker.
  class DocumentRecord < Resource
    property :document_record_id, key: "DocumentsOfRecordId"
    property :category_code, key: "CategoryCode"
    property :subcategory_code, key: "SubCategoryCode"
    property :document_type, key: "DocumentType"
    property :system_document_type, key: "SystemDocumentType"
    property :person_id, key: "PersonId"
    property :person_number, key: "PersonNumber"
    property :display_name, key: "DisplayName"
    property :creation_date, key: "CreationDate"
    property :last_update_date, key: "LastUpdateDate"
    child_resource :attachments, resource: Attachment

    def canonical_id
      document_record_id
    end
  end
end
