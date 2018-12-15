object false
child(@payments => :payments) do
  attributes :id, :payment_method_id, :amount
end

node(:count) { @payments.count }
