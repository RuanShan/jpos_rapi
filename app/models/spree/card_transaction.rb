class Spree::CardTransaction < ActiveRecord::Base
  belongs_to :card
  belongs_to :order

  scope :reverse_chronological, -> { order(Arel.sql('spree_card_transactions.completed_at IS NULL'), completed_at: :desc, created_at: :desc) }

  validates :amount, :card, presence: true


end
