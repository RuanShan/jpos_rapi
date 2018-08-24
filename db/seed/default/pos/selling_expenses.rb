if  Selling::Expense.count == 0
  puts "\tCreating default  Selling::Expense..."
  shipping_category = Spree::ShippingCategory.find_or_create_by(name: 'Gift Card')
  [ {name: "门店一般费用100", price: 100 },
    {name: "门店税费", price: 500 },
    {name: "门店其他费用", price: 1500 }].each{|attrs|
      product = Selling::Expense.new(attrs) do|card|
        card.available_on = Time.now
        card.shipping_category_id =  shipping_category.id
      end
    product.save!
  }

end
