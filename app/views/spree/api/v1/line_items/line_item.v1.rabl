object @line_item
attributes *line_item_attributes
node(:created_at, &:created_at)
node(:total, &:total)
node(:worker_name, &:worker_name)
node(:store_name, &:store_name)
