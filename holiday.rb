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
    celebration.each do |some_attr, val|
      puts "\t Your kingdom's #{ some_attr } is changed by #{ val }"
      game.status.apply(some_attr, val)
    end
  end
end
