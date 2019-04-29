require "active_storage/service/aliyun_service"

class ActiveStorage::PurgeJob < ActiveStorage::BaseJob
  def perform(blob)
    blob.purge unless blob.attachments.present?
  end
end

# 
# ActiveStorage::Service::AliyunService.class_eval do
#   # ipad 上传图片随机出现不成功。 提示 InvalidDigest
#   # https://www.alibabacloud.com/help/zh/doc-detail/32005.htm
#   def headers_for_direct_upload(key, content_type:, checksum:, **)
#     checksum = ''
#     date = Time.now.httpdate
#     {
#       "Content-Type" => content_type,
#       "Content-MD5" => checksum,
#       "Authorization" => authorization(key, content_type, checksum, date),
#       "x-oss-date" => date,
#     }
#   end
# end
