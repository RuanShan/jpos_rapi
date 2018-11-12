
unless Spree::Factory.where(code: 'factory0').exists?
  5.times{ |i|
    store = Spree::Factory.new do |s|
      s.code              = "factory#{i}"
      s.name              = "示例工厂#{i}"
    end
    store.save!
  }

end
