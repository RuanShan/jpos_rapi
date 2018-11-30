# use group_id instead of group_number
Spree::LineItem.all.each{| li |
  group = Spree::LineItemGroup.where( number: li.group_number).first
  if group
    li.group_id = group.id
    li.save
  else
    li.destroy
  end
}


# associate store and stock_location
Spree::Store.all.each{| store |
  if store.stock_location.blank?
    stock_location_attributes = { name: store.name, active: true, propagate_all_variants: true }
    store.create_stock_location! stock_location_attributes
    store.save
  end
}



#fix track_inventory, set true for selling:
Selling::Service.all.each{|product|
  product.variants_including_master.each{|variant|
    variant.track_inventory = false
    variant.save
  }
}
Selling::PrepaidCard.all.each{|product|
  product.variants_including_master.each{|variant|
    variant.track_inventory = false
    variant.save
  }
}
