require "oracle_hcm/resource"

module OracleHcm
  # An Attachment is a child resource of a Document Record (or Document of
  # Record), and stores upload file data and metadata.
  class Attachment < Resource
    property :attachment_document_id, key: "AttachmentDocumentId"
    property :content_type, key: "UploadFileContentType"
    property :content_size, key: "UploadFileContentLength"
    property :title, key: "Title"

    # Download the file via a readable IO object.
    def download
      io = StringIO.new
      res = client.connection.get do |req|
        req.url uri(rel: "enclosure")
        req.options.on_data = Proc.new do |chunk, total_bytes|
          io << chunk
        end
      end
      if res.success?
        io.rewind
        io
      else
        nil
      end
    end
  end
end
