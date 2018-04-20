class Spree::CardTransaction < ActiveRecord::Base
  belongs_to :card
  belongs_to :order

  validates :amount, :card, presence: true

  after_create :update_card_current_value


  private

  def update_card_current_value
    self.card.update_attribute :current_value, self.card.transactions.sum(:amount)
  end

end
