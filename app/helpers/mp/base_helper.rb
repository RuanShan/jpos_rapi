module Mp::BaseHelper


  def group_first_image_url( group )


    image = group.first_image
    if image.present?
      image.attachment.url
    else
      image_url( group.missing_image_path )
    end
  end
end
