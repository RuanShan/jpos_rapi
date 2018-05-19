module Selling
  class PrepaidCard < Spree::Product
    enum card_expire_in: { year: 0, month: 30, week: 7 }, _suffix: true

    [
      :card_discount_percent, :card_discount_amount, :card_expire_in
    ].each do |method_name|
      delegate method_name, :"#{method_name}=", to: :find_or_build_master
    end
  end
end
