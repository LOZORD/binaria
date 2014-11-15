class Holiday
  DAYS_IN_YEAR = 365
  attr_accessor :name, :date, :celebration, :game
  def initialize (init_obj)
    @@holiday_count |= 1

    @name = init_obj[:name] || 'Festivus Version ' + @@holiday_count
    @celebration = init_obj[:celebration] || {}
    @date = init_obj[:day] % DAYS_IN_YEAR || 0

    @@holiday_count += 1
  end

  def today? (today)
    date == today % DAYS_IN_YEAR
  end

  def celebrate!
    # TODO
  end
end
