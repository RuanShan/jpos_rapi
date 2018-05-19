module Selling
  class TimesCard < Spree::Product
    enum card_expire_in: { year: 365, month: 30, week: 7 }, _suffix: true

  end
end
