require "oracle_hcm/resource"

module OracleHcm
  class DocumentRecord < Resource
    property :document_record_id, key: "DocumentsOfRecordId"
    property :category_code, key: "CategoryCode"
    property :subcategory_code, key: "SubCategoryCode"
    property :document_type, key: "DocumentType"
    property :system_document_type, key: "SystemDocumentType"
  end
end
