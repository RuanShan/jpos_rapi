relation_types = [
  { name:"储值卡打折商品", applies_to: "Selling::PrepaidCard" },
  { name:"次卡服务", applies_to: "Selling::TimesCard" },
  { name:"保养年卡", applies_to: "Selling::AnnualCard" }]
relation_types.each{|attrs|
#  Spree::RelationType.find_or_create_by!(attrs )
}

Selling::PrepaidCard.all.each{|card|
  #card = Selling::PrepaidCard.friendly.find 'prepaidcard1000'
  relation_type = Spree::RelationType.find_or_create_by!(name: card.name,
    applies_to: "#{card.type}##{card.id}")

  products = Selling::Service.all
  products.each{|product|
      # 1000元 7折 皮衣，皮包，貂皮 9折
      discount_percent = card.card_discount_percent
      if product.price == 1000
        discount_percent = 90
      elsif  product.price == 3000
        discount_percent = 80
      elsif  product.price == 8000
        discount_percent = 70
      end
      relation_type.relations.create!( relatable: card, related_to: product,
        discount_percent: discount_percent)
  }
}
