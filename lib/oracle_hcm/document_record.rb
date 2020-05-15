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
    child_resource :attachments, resource: Attachment

    def canonical_id
      document_record_id
    end
  end
end
