if  Spree::ExpenseCategory.count == 0
  puts "\tCreating default  Spree::ExpenseCategory..."
  [ {name: "门店一般费用100" },
    {name: "门店税费" },
    {name: "门店其他费用" }].each{|attrs|
      product = Spree::ExpenseCategory.new(attrs) do|card|
      end
    product.save!
  }

end
