object false
node(:count) { @sale_days.count }

child(@sale_days => :sale_days) do
  attributes *sale_day_attributes
end
