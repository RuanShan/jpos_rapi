class SaleDay < ApplicationRecord
  # 添加 日注册，月注册 scope
  extend BetterDateScope
  better_date_scope day: [:today, :week]

  belongs_to :seller, class_name: "User"
  has_many :new_orders, class_name: 'Spree::Order', primary_key: 'user_id', foreign_key: 'created_by_id'
  has_many :new_cards, class_name: 'Spree::Card', primary_key: 'user_id', foreign_key: 'created_by_id'
  has_many :new_customers, class_name: 'Spree::User', primary_key: 'user_id', foreign_key: 'created_by_id'

  def valuable_rate
     valuable_member_count == 0 ? 0 : ( valuable_member_count/ member_count.to_f ).round(2)
  end

  def display_valuable_rate
    "%i%" % (valuable_rate*100)
  end

  # def self.to_csv(options = {})
  #   CSV.generate(options) do |csv|
  #     csv << ["日期", "推广链接点击数", "注册数", "新注册并存款", "注册存款转化率"]
  #     all.each do |sale_day|
  #       values = [sale_day.day, sale_day.clink_visits, sale_day.member_count, sale_day.valuable_member_count, sale_day.display_valuable_rate]
  #       csv << values
  #     end
  #   end
  # end

  def recompute_processed_line_items_count
    #update processed_line_items_count: Spree::LineItem.where( worer_id: self.id, work)
  end

end
