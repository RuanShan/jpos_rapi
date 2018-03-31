class GameAward < ApplicationRecord
  has_many :game_award_players, dependent: :delete_all
  belongs_to :game_round
  acts_as_list scope: [:game_round_id, :type]

  # 0:score 排名  6:满足条件抽奖
  enum taxon: { lot: 6, score: 0}, _prefix: true
  #不能验证，通过GameRound 创建时无法验证，
  #validates_presence_of :game_round


  #给游戏人员发奖， CardPrize,CashPrize 可以重载他。
  def offer_to( game_player)

  end

  def available_to?( game_player )
    false
  end

end
