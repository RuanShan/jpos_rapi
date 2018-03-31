module Case
  module GameRoundsHelper

    # field: delivery_time_at_gt_all
    # 修正显示 时间问题 Thu, 23 Nov 2017 02:55:00 CST +08:00 => 2017-11-13 02:55
    def display_delivery_time_at( field  )
      time = @q.send(field)
      return if time.blank?
      # time is array
      I18n.l( time.first, { format: :search_time })
    end
  end
end
