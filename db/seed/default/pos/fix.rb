Spree::LineItem.all.each{| li |
  group = Spree::LineItemGroup.where( number: li.group_number).first
  if group
    li.group_id = group.id
    li.save
  else
    li.destroy
  end
}
