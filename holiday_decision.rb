class Holiday_Decision < Decision
  attr_accessor :name
  def initialize (init_obj)
    super(init_obj)
    @name = init_obj[:holiday_name]
  end

  def decide! (choice, day)
    result = choice == :yes ? yes : no
    game = asker.game
    status = game.status
    celebration = nil
    result.each do |prop, val|
      if prop.to_sym != :celebration
        status.update(prop, val)
      elsif prop.to_sym == :celebration
        celebration = val
      else
        throw BadPropertyException
      end
    end

    unless celebration.nil?
      holiday_calendar = asker.game.holidays

      init_obj = {
                    name: name,
                    celebration: celebration,
                    day: day
                    game: asker.game
                 }

      new_holiday = Holiday.new(init_obj)

      holiday_calendar[day] << new_holiday
    end

    is_decided = true
  end

end
