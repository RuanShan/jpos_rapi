module Spree

  class Api::V1::Statis::DaysController  < Api::V1::BaseController

    def week
      @week_statis = []

      sale_days = SaleDay.week
      now = DateTime.current.to_date

      (now-6).upto(now){|day|
        selected_sale_days = sale_days.select{|sale| sale.day == day}
        statis = {}
        [:new_orders_count,:new_customers_count,:new_cards_count].each{|key|
          statis[key] =  selected_sale_days.sum(&key)
        }
        @week_statis<<statis
      }

    end

    def today
      @statis = {}
      sale_days = SaleDay.today
      [:new_orders_count,:new_customers_count,:new_cards_count].each{|key|
        @statis[key] =  sale_days.sum(&key)
      }
      Rails.logger.debug " @statis=#{@statis}"
    end

    def total
      @statis = {}
      sale_days = SaleDay.all
      [:new_orders_count,:new_customers_count,:new_cards_count].each{|key|
        @statis[key] =  sale_days.sum(&key)
      }
      Rails.logger.debug " @statis=#{@statis}"
    end

  end

end
