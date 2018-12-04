if Selling::PrepaidCard.count == 0
  puts "\tCreating default PrepaidCard..."
  shipping_category = Spree::ShippingCategory.find_or_create_by(name: 'Card')

  [ {name: "会员卡1000打7折", price: 1000, card_discount_percent: 70},
    {name: "会员卡3000打6折", price: 3000, card_discount_percent: 60},
    {name: "会员卡8000打5折", price: 8000, card_discount_percent: 50}].each{|attrs|
      product = Selling::PrepaidCard.new(attrs) do|card|
        card.available_on = Time.now
        card.shipping_category_id =  shipping_category.id
      end
    product.save!
  }

end


#
if Selling::TimesCard.count == 0
  shipping_category = Spree::ShippingCategory.find_or_create_by(name: 'Card')
  [ {name: "干洗鞋次卡300/10次", price: 300, card_times: 10},
    {name: "干洗鞋次卡500/20次", price: 500, card_times: 20}].each{|attrs|
      product = Selling::TimesCard.new(attrs) do|card|
        card.available_on = Time.now
        card.shipping_category_id =  shipping_category.id
      end
    product.save!
  }
end
