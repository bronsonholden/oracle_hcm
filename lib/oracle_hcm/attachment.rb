require "oracle_hcm/resource"

module OracleHcm
  class Attachment < Resource
    property :attachment_document_id, key: "AttachmentDocumentId"
    property :content_type, key: "UploadFileContentType"
    property :content_size, key: "UploadFileContentLength"
    property :title, key: "Title"

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
