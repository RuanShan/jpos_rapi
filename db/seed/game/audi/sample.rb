game = Game.code_runlin_dumpling.where( name: '新春go年货' ).first_or_create
game_round_attrs = { name: '新春go年货', game: game }

game_round = GameRound.where( game_round_attrs ).first_or_create

first_achieved_prize_attrs = { name: '幸运参与奖', prize_name:'玻璃清洗剂（防冻）2瓶', game_round: game_round, taxon: GameAward.taxons[:lot],
  day_first_achieved_required: true, day_probability: 70, day_prize_count: 100
 }

Prize::FirstAchievedPrize.where( first_achieved_prize_attrs ).first_or_create
