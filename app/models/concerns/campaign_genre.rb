module CampaignGenre

  extend ActiveSupport::Concern
  included do
    after_create :created_callback_by_genre
  end

  def created_callback_by_genre
    if genre_runlin_car_game?
        send "after_#{genre}_created"
    end
  end

  def after_runlin_car_game_created
    game = Game.find_by_code :runlin_car_game
    game_round = game.game_rounds.create!( campaign: self, creator: self.creator )
  end

end
