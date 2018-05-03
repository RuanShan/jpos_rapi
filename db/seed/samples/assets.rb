unless ENV['SKIP_SAMPLE_IMAGES']
  Spree::Sample.load_sample("products")
  Spree::Sample.load_sample("variants")

  products = {}
  products[:ror_baseball_jersey] = Spree::Product.find_by!(name: "保养鞋")
  products[:ror_tote] = Spree::Product.find_by!(name: "喷磨砂")
  products[:ror_bag] = Spree::Product.find_by!(name: "干洗鞋")
  products[:ror_jr_spaghetti] = Spree::Product.find_by!(name: "清洗鞋")
  products[:ror_mug] = Spree::Product.find_by!(name: "翻新鞋")
  products[:ror_ringer] = Spree::Product.find_by!(name: "修复鞋")

  products[:spree_baseball_jersey] = Spree::Product.find_by!(name: "清洗上色保养")
  products[:spree_stein] = Spree::Product.find_by!(name: "清洗特级保养")
  products[:spree_jr_spaghetti] = Spree::Product.find_by!(name: "封边油")
  products[:spree_mug] = Spree::Product.find_by!(name: "维修类")


  def image(name, type = "jpeg")
    images_path = Pathname.new(File.dirname(__FILE__)) + "images"
    path = images_path + file_name(name, type)
    return false if !File.exist?(path)
    File.open(path)
  end

  def file_name(name, type = "jpeg")
    "#{name}.#{type}"
  end

  images = {
    products[:ror_tote].master => [
      {
        name: file_name("ror_tote"),
        attachment: image("ror_tote")
      },
      {
        name: file_name("ror_tote_back"),
        attachment: image("ror_tote_back")
      }
    ],
    products[:ror_bag].master => [
      {
        name: file_name("ror_bag"),
        attachment: image("ror_bag")
      }
    ],
    products[:ror_baseball_jersey].master => [
      {
        name: file_name("ror_baseball"),
        attachment: image("ror_baseball")
      },
      {
        name: file_name("ror_baseball_back"),
        attachment: image("ror_baseball_back")
      }
    ],
    products[:ror_jr_spaghetti].master => [
      {
        name: file_name("ror_jr_spaghetti"),
        attachment: image("ror_jr_spaghetti")
      }
    ],
    products[:ror_mug].master => [
      {
        name: file_name("ror_mug"),
        attachment: image("ror_mug")
      },
      {
        name: file_name("ror_mug_back"),
        attachment: image("ror_mug_back")
      }
    ],
    products[:ror_ringer].master => [
      {
        name: file_name("ror_ringer"),
        attachment: image("ror_ringer")
      },
      {
        name: file_name("ror_ringer_back"),
        attachment: image("ror_ringer_back")
      }
    ],

    products[:spree_jr_spaghetti].master => [
      {
        name: file_name("spree_spaghetti"),
        attachment: image("spree_spaghetti")
      }
    ],
    products[:spree_baseball_jersey].master => [
      {
        name: file_name("spree_jersey"),
        attachment: image("spree_jersey")
      },
      {
        name: file_name("spree_jersey_back"),
        attachment: image("spree_jersey_back")
      }
    ],
    products[:spree_stein].master => [
      {
        name: file_name("spree_stein"),
        attachment: image("spree_stein")
      },
      {
        name: file_name("spree_stein_back"),
        attachment: image("spree_stein_back")
      }
    ],
    products[:spree_mug].master => [
      {
        name: file_name("spree_mug"),
        attachment: image("spree_mug")
      },
      {
        name: file_name("spree_mug_back"),
        attachment: image("spree_mug_back")
      }
    ],
  }

  # products[:ror_baseball_jersey].variants.each do |variant|
  #   color = variant.option_value("tshirt-color").downcase
  #
  #   if variant.images.where(attachment_file_name: file_name("ror_baseball_jersey_#{color}", "png")).none?
  #     main_image = image("ror_baseball_jersey_#{color}", "png")
  #     variant.images.create!(attachment: main_image)
  #   end
  #
  #   if variant.images.where(attachment_file_name: file_name("ror_baseball_jersey_back_#{color}", "png")).none?
  #     back_image = image("ror_baseball_jersey_back_#{color}", "png")
  #     variant.images.create!(attachment: back_image)
  #   end
  # end

  images.each do |variant, attachments|
    puts "Loading images for #{variant.product.name}"
    attachments.each do |attrs|
      file_name = attrs.delete(:name)

      if variant.images.where(attachment_file_name: file_name).none?
        variant.images.create!(attrs)
      end
    end
  end
end
