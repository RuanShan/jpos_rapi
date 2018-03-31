FactoryBot.define do
  factory :game_player do
    openid {"openid-#{DateTime.current}"}
    game_round
  end
end
