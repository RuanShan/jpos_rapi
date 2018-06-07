module Selling
  class TimesCard < Spree::Product
    default_scope { where( card_style: 1 ) }
    enum card_expire_in: { year: 365, month: 30, week: 7 }, _suffix: true

  end
end
