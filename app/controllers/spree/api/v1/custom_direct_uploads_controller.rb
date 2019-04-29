module Spree
  module Api
    module V1
      class CustomDirectUploadsController < Spree::Api::BaseController

         def create
          blob = ActiveStorage::Blob.create_before_direct_upload!(blob_args)
          render json: direct_upload_json(blob)
        end

        private
          def blob_args
            params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type, :metadata).to_h.symbolize_keys
          end

          def direct_upload_json(blob)
            # ipad 上传图片随机出现不成功。
            headers_except_content_md5	 =  blob.service_headers_for_direct_upload.except("Content-MD5")
            blob.as_json(root: false, methods: :signed_id).merge(direct_upload: {
              url: blob.service_url_for_direct_upload( ),
              headers: headers_except_content_md5
            })
          end
      end
    end
  end
end
