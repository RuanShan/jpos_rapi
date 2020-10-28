module Spree
  module Api
    module V1
      class SaleDaysController  < BaseController

        # 查询某一天的统计信息
        # 参数
        #   q: ransack 参数
        def day
          @sale_day = SaleDay.new()
          sale_days = get_selected_sale_days
          get_stat_cols.each{|key|
            val = sale_days.sum(&key)
            @sale_day.send( "#{key}=", val )
          }
        end

        def today
          @sale_day = SaleDay.new()
          if params[:q]
            sale_days =get_selected_sale_days
          else
            sale_days = SaleDay.where( store: Spree::Site.current.stores ).today
          end
          get_stat_cols.each{|key|
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

            get_stat_cols.each{|key|
              sale_day.send( "#{key}=", selected_sale_days.sum(&key) )
            }
            @sale_days << sale_day
          }

        end

        # 功能：
        # 取得一定期间，每一天的统计数据
        # params
        #   days - 选择日期数组
        #   start_at - 选择日期开始时间
        #   end_at - 选择日期结束时间
        # 当参数 days 存在时，使用days指定的日期，
        # 当参数 days 不存在， start_at, end_at存在时，选择这个区间的所有日期
        def days

          day_sale_days_map = {}
          sale_days = get_selected_sale_days

          sale_days.each {|sale_day|
            day = sale_day.day
            if day_sale_days_map[day].blank?
               day_sale_days_map[day] = SaleDay.new(day: day)
            end
            sale_day_sum =  day_sale_days_map[day]

            sale_day_sum.service_total += sale_day.service_total
            sale_day_sum.deposit_total += sale_day.deposit_total
            sale_day_sum.new_orders_count += sale_day.new_orders_count
            sale_day_sum.service_order_count += sale_day.service_order_count
            sale_day_sum.new_customers_count += sale_day.new_customers_count
            sale_day_sum.new_cards_count += sale_day.new_cards_count

          }
          @sale_days = day_sale_days_map.fetch_values *day_sale_days_map.keys.sort

        end

        # 功能
        # 一定时间区间的汇总统计
        # 参数
        #   from - 开始日期
        #   to - 结束日期
        # 如果 from, to 为空， 表示取得所有的汇总统计
        def total
          @sale_day = SaleDay.new(day: Date.current)

          if params[:q]
            # day_gteq: "2020-02-24T16:00:00.000Z", day_lteq: "2020-02-25T15:59:59.000Z"
            # 这里需要把时间转为日期，否则统计数据不准
            if params[:q][:day_gteq]
              params[:q][:day_gteq] = Time.parse( params[:q][:day_gteq] ).localtime.to_date()
            end
            if params[:q][:day_lteq]
              params[:q][:day_lteq] = Time.parse( params[:q][:day_lteq] ).localtime.to_date()
            end
            Rails.logger.debug "params[:q] =#{params[:q].inspect}"
            sale_days = get_selected_sale_days
          else
            sale_days = SaleDay.where( store: Spree::Site.current.stores )
          end
          get_stat_cols.each{|key|
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


        def get_selected_sale_days(  )
          days = []
          # if params[:days].present?
          #   params[:days].each{|day|
          #     days.push( Date.parse(day) )
          #   }
          #   sale_days =  SaleDay.where( day: days ).order(:day)
          # end
          #
          # if params[:start_at] && params[:end_at]
          #   start_at = Date.parse(params[:start_at])
          #   end_at = Date.parse(params[:end_at])
          #   sale_days =  SaleDay.where( ["day>=? AND day<=?"], start_at, end_at ).order(:day)
          # end
          fixRansackQuery()
          sale_days = SaleDay.ransack( params[:q] ).result

        end

        def get_stat_cols
          return  [:service_total, :deposit_total, :service_order_count, :new_orders_count,:new_customers_count,:new_cards_count, :service_posable_total]
        end

      end
    end
  end
end
