class Holiday
  DAYS_IN_YEAR = 365
  attr_accessor :name, :date, :celebration, :game
  def initialize (init_obj)
    @@holiday_count ||= 1
    @game = init_obj[:game]
    fail 'A Holiday needs to be associated with a Game!' unless @game
    @name = init_obj[:name] || 'Festivus Version ' + @@holiday_count.to_s
    @celebration = init_obj[:celebration] || {}
    @date = init_obj[:day] % DAYS_IN_YEAR || 0

    @@holiday_count += 1
  end

  def today?
    date == game.cal_day_today
  end

  def celebrate!
    puts "Happy #{ name }!"
    celebration.non_zero_changes.each do |k,v|
      StatusChange.print_result(k,v)
    end
    game.status.update_with_change celebration
  end
end
