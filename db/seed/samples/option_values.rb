Spree::Sample.load_sample("option_types")

size = Spree::OptionType.find_by!(presentation: "Size")

option_values_attributes = [
  {
    name: "低规",
    presentation: "S",
    position: 1,
    option_type: size
  },
  {
    name: "中规",
    presentation: "M",
    position: 2,
    option_type: size
  },
  {
    name: "高规",
    presentation: "L",
    position: 3,
    option_type: size
  }

]

option_values_attributes.each do |attrs|
  Spree::OptionValue.where(attrs).first_or_create!
end
