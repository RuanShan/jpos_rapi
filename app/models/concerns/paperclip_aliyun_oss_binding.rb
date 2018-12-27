# include into model
module PaperclipAliyunOssBinding
  # original path and url
  # :url  => "/shops/:rails_env/:site/ckeditor_assets/pictures/:id/:style_:basename.:extension",
  # :path => ":rails_root/public/shops/:rails_env/:site/ckeditor_assets/pictures/:id/:style_:basename.:extension",

  def self.extended( base )
    if base.storage_aliyun?
      base.fix_path_for_aliyun_oss
    end
  end

  def fix_path_for_aliyun_oss
    # ex. Spree::Taxon   path = 1/taxon/1_test.jpg,  :aliyun_style start with @
    # taxon/post/
    path = "/:store_id/:class/:id_:filename"
    #make sure each
    attachment_key = :attachment  # spree_image/ spree_template_file
    attachment_key = :icon if self.name == 'Spree::Taxon'
    attachment_key = :data if self.name == 'Ckeditor::Picture' #Ckeditor::Picture,
    attachment_key = :data if self.name == 'Ckeditor::AttachmentFile'    #Ckeditor::AttachmentFile
    attachment_definitions[attachment_key][:path] = path
    attachment_definitions[attachment_key][:url] = 'http://:aliyun_host'+path+':aliyun_style'
    attachment_definitions[attachment_key][:styles] = {} #no need styles anymore. it is supproted by oss style
    attachment_definitions[attachment_key][:use_timestamp] = false # no timestamp end of url
    attachment_definitions[attachment_key][:escape_url] = false
  end

  def storage_aliyun?
   (attachment_definitions[:storage]||Paperclip::Attachment.default_options[:storage]) == :aliyun
  end
end
