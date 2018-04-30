module Spree
  module Api
    module V1
      class SaleDaysController  < Spree::Api::V1::BaseController



        def selected_day
          day = get_selected_day
          @sale_day = SaleDay.new(day: day)
          sale_days = SaleDay.on_date day
          [:new_orders_count,:new_customers_count,:new_cards_count].each{|key|
            val = sale_days.sum(&key)
            @sale_day.send( "#{key}=", val )
          }
        end

        def today
          @sale_day = SaleDay.new(day: get_selected_day)
          sale_days = SaleDay.today
          [:new_orders_count,:new_customers_count,:new_cards_count].each{|key|
            val = sale_days.sum(&key)
            @sale_day.send( "#{key}=", val )
          }

        end

        def week
          @sale_days = []

          sale_days = SaleDay.week
          now = DateTime.current.to_date

          (now-6).upto(now){|day|
            sale_day = SaleDay.new(day: day)

            selected_sale_days = sale_days.select{|sale| sale.day == day}

            [:new_orders_count,:new_customers_count,:new_cards_count].each{|key|
              sale_day.send( "#{key}=", selected_sale_days.sum(&key) )
            }
            @sale_days<<sale_day
          }

        end

        def selected_days
          days = get_selected_days
          @sale_days = []

          sale_days = SaleDay.where( day: days )

          days.each {|day|
            sale_day = SaleDay.new(day: day)

            selected_sale_days = sale_days.select{|sale| sale.day == day}

            [:new_orders_count,:new_customers_count,:new_cards_count].each{|key|
              sale_day.send( "#{key}=", selected_sale_days.sum(&key) )
            }
            @sale_days<<sale_day
          }

        end

        def total
          @sale_day = SaleDay.new(day: Date.current)
          sale_days = SaleDay.all
          [:new_orders_count,:new_customers_count,:new_cards_count].each{|key|
            @sale_day.send( "#{key}=", sale_days.sum(&key) )
          }
        end

        private
        def get_selected_day
          if params[:day].present?
            Date.pare( params[:day] )
          else
            Date.current
          end
        end

        def get_selected_days
          days = []
          if params[:days].present?
            params[:days].each{
              days.push Date.pare(day)
            }
          end
          days
        end

      end
    end
  end
end
