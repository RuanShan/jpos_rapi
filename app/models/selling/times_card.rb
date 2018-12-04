module Selling
  class TimesCard < Spree::Product
    default_scope { where( card_style: 1 ) }
    enum card_expire_in: { year: 365, month: 30, week: 7 }, _suffix: true

    [
      :card_times #次卡总共次数
    ].each do |method_name|
      delegate method_name, :"#{method_name}=", to: :find_or_build_master
    end

  end
end
