Spree::Sample.load_sample("products")

size = Spree::OptionType.find_by!(presentation: "Size")

ror_baseball_jersey = Spree::Product.all.each{|product|
  product.option_types = [size]
  product.save!
}


#spree_baseball_jersey = Spree::Product.find_by!(name: "Spree Baseball Jersey")
#spree_baseball_jersey.option_types = [size, color]
#spree_baseball_jersey.save!
