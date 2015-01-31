class HolidayDecision < Decision
  attr_accessor :name, :new_holiday
  def initialize (init_obj)
    super(init_obj)
    @name = init_obj[:holiday_name]
    init_obj = {
                  game:         @asker.game,
                  name:         @name,
                  celebration:  init_obj[:yes][:celebration],
                  day:          @asker.game.cal_day_today
               }
    @new_holiday = Holiday.new(init_obj)
  end

  def decide! (choice)
    result = choice == :yes ? yes : no

    if result == :yes
      puts "JOYOUS #{ name } TO YOU DEAR LEADER!".bold_green_on_yellow
      holiday_calendar = asker.game.holidays
      holiday_calendar[game.cal_day_today] << new_holiday
    end

    asker.game.status.update_with_change result

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
