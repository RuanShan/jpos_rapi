module Mp::BaseHelper


  def group_first_image_url( group )


    url = group_image_urls(group).first
    if url.blank?
      url = image_url( group.missing_image_path )
    end
    url
  end

  def group_image_urls( group, stylename=:large )
    group.images.map{|image|
      if Rails.application.config.active_storage.service.to_s =~ /aliyun/
        image.attachment.service_url( params: { "x-oss-process" => "style/#{stylename}" })
      else
        main_app.url_for( image.url(style) )
      end
    }
  end

end
