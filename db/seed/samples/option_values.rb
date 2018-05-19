Spree::Sample.load_sample("option_types")

size = Spree::OptionType.find_by!(presentation: "规格")

option_values_attributes = [
  {
    name: "低规",
    presentation: "低规",
    position: 1,
    option_type: size
  },
  {
    name: "中规",
    presentation: "中规",
    position: 2,
    option_type: size
  },
  {
    name: "高规",
    presentation: "高规",
    position: 3,
    option_type: size
  }

]

option_values_attributes.each do |attrs|
  Spree::OptionValue.where(attrs).first_or_create!
end
