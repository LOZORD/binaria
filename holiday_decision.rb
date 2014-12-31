class Holiday_Decision < Decision
  attr_accessor :name
  def initialize (init_obj)
    super(init_obj)
    @name = init_obj[:holiday_name]
  end

  def decide! (choice)
    result = choice == :yes ? yes : no
    if result == :yes
      puts "JOYOUS #{ name } TO YOU DEAR LEADER!".bold_green_on_yellow
    end
    game = asker.game
    status = game.status
    celebration = nil
    result.each do |prop, val|
      if prop.to_sym != :celebration
        status.update(prop, val)
      elsif prop.to_sym == :celebration
        celebration = val
      else
        fail "Status #{status} has no corresponding property `#{prop}`".red
      end
    end

    unless celebration.nil?
      holiday_calendar = asker.game.holidays

      init_obj = {
                    game:         game,
                    name:         name,
                    celebration:  celebration,
                    day:          game.cal_day_today,
                    game:         asker.game
                 }

      new_holiday = Holiday.new(init_obj)

      holiday_calendar[game.cal_day_today] << new_holiday
    end

    @is_decided = true
  end

  def print_result(key, value)
    if (value.is_a? Hash) && (!value.empty?)
      puts "Every year on this day (#{ asker.game.human_cal_day_today }):".yellow
      value.each { |k, v| super(k, v) }
    else
      super(key, value)
    end
  end
end
