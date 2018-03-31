module GameRoundsHelper
  def screen_background_url(game_round)
    game_round.screen_background.try{ attachment.url } || asset_path('game/default/screen.jpg')
  end
  def mobile_background_url(game_round)
    game_round.mobile_background.try{ attachment.url } || asset_path('game/default/mobile.jpg')
  end
  def logo_url(game_round)
    game_round.logo.try{ attachment.url } || asset_path('game/default/logo.jpg')
  end

  def game_name_image( game_round )
    image_tag "game/#{game_round.game_code}/name.png", class: 'icon'
  end

  def display_start_and_end_at( )
    start_at = @game_round.start_at || DateTime.current
    end_at = @game_round.end_at || DateTime.current
    I18n.l( start_at, { format: :long }) + ' - '+  I18n.l( end_at, { format: :long })
  end

  # @option_value- tonoon , tonignt, nenoon, nenight
  def delivery_time_option_enable?( option_value)
    # tonoon: 0, tonignt: 1, nenoon: 10, nenight: 11
    # 11:00以前 今中，今晚，明中
    # 11:00以后 今晚，明中，明晚
    # 17:00以后 明中，明晚
    # 00:00以后 今中，今晚，明中
    now = DateTime.current
    noon =  DateTime.current.beginning_of_day.advance( hours: 11 )
    night = DateTime.current.beginning_of_day.advance( hours: 17 )

    if now < noon
      [  'tonoon' , 'tonignt', 'nenoon'].include? option_value
    elsif now >= noon && now < night
      [  'tonignt', 'nenoon', 'nenight'].include? option_value
    else
      [ 'nenoon', 'nenight'].include? option_value
    end

  end

  # @option_value- current option value
  # @last_option_value- selected option value last time, it may be invalid
  def delivery_time_option_checked?(  option_value, last_option_value )
    # tonoon: 0, tonignt: 1, nenoon: 10, nenight: 11
    # 11:30以前 今中，今晚，明中
    # 11:30以后 今晚，明中，明晚
    # 17:30以后 明中，明晚
    # 00:00以后 今中，今晚，明中
    now = DateTime.current
    noon =  DateTime.current.beginning_of_day.advance( hours: 11 )
    night = DateTime.current.beginning_of_day.advance( hours: 17 )

    if now < noon
      [  'tonoon' , 'tonignt', 'nenoon'].include?( last_option_value ) ? option_value==last_option_value :  'tonoon'==option_value
    elsif now >= noon && now < night
      [  'tonignt', 'nenoon', 'nenight'].include?( last_option_value ) ? option_value==last_option_value :  'tonignt'==option_value
    else
      [ 'nenoon', 'nenight'].include?( last_option_value ) ? option_value==last_option_value :  'nenoon'==option_value
    end

  end

end
