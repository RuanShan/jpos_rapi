#会员卡的充值记录，消费记录由payment保存
class Spree::CardTransaction < ActiveRecord::Base
  belongs_to :card
  belongs_to :order

  scope :reverse_chronological, -> { order(Arel.sql('spree_card_transactions.completed_at IS NULL'), completed_at: :desc, created_at: :desc) }
  scope :deposit, ->{ where reason: :deposit }

  validates :amount, :card, presence: true
  #        充值       消费       取消回退   转移(其它卡转过来)
  #reason :deposit,  consume,   canceled, transfer


  state_machine initial: :pending do
    after_transition :on=> :capture, :do => :adjust_card_amount_used
    after_transition :on=> :deposit, :do => :adjust_card_amount

    after_transition :completed => :canceled, :do => :adjust_card_amount_used

    #付款
    event :capture do
      transition [:pending] => :completed
    end
    #充值
    event :deposit do
      transition [:pending] => :completed
    end

  end

  def amount_remaining
    amount + amount_left  #充值数量+充值前剩余数量
  end

  def adjust_card_amount_used
    Rails.logger.debug "adjust_card_amount. state=#{state} "
    Rails.logger.debug "original card amount_used #{card.amount_used}"
    # 会员卡支付时self.amount 为负数，便于统计余额。所以这里需要 减
    self.card.amount_used -= self.amount
    self.card.save!
  end

  def adjust_card_amount
    Rails.logger.debug "adjust_card_amount. state=#{state} "
    Rails.logger.debug "original card amount #{card.amount}"
    #设置充值顺序，以便知道这是第几次充值
    self.update_attribute :position, (self.card.card_transactions.deposit.maximum(:position).to_i + 1)
    self.card.amount += self.amount
    self.card.save!
  end
end
