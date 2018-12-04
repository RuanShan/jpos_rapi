module Selling
  class AnnualCard < Spree::Product
    enum card_expire_in: { year: 0, month: 30, week: 7 }, _suffix: true


  end
end
