
rt = Spree::RelationType.find_or_create_by!(name: 'PrepaidCard discount products', applies_to: 'Selling::PrepaidCard')

card = Selling::PrepaidCard.first


products = Selling::Product.limit(4)
products.each{|product|
  rt.relations.create!( relatable: card, related_to: product )
}
