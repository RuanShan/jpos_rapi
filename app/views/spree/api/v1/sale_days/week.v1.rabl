collection @sale_days

child(@sale_days => :sale_days) do
  attributes *sale_day_attributes
end
