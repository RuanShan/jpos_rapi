#会员卡的充值记录，消费记录由payment保存
class Spree::CardTransaction < ActiveRecord::Base
  belongs_to :card
  belongs_to :order

  scope :reverse_chronological, -> { order(Arel.sql('spree_card_transactions.completed_at IS NULL'), completed_at: :desc, created_at: :desc) }

  validates :amount, :card, presence: true
  #        充值       消费       取消回退
  #reason :deposit,  consume,   canceled


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



  def adjust_card_amount_used
    Rails.logger.debug "adjust_card_amount. state=#{state} "
    Rails.logger.debug "original card amount_used #{card.amount_used}"
    self.card.amount_used += self.amount
    self.card.save!
  end

  def adjust_card_amount
    Rails.logger.debug "adjust_card_amount. state=#{state} "
    Rails.logger.debug "original card amount #{card.amount}"
    self.card.amount += self.amount
    self.card.save!
  end
end
