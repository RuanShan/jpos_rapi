option_types_attributes = [
  {
    name: "size",
    presentation: "Size",
    position: 1
  }
]

option_types_attributes.each do |attrs|
  Spree::OptionType.where(attrs).first_or_create!
end
