class Neighbor
  attr_accessor :name, :status, :mood, :ambassador
  def initialize (init_obj)
    @@neighbor_count ||= 1
    @name = init_obj[:name] || 'Blargistan' + @@neighbor_count
    @status = Status.new (init_obj[:status] || {})
    @mood = init_obj[:mood] || Status::MAX_MOOD / 2
    @ambassador  = init_obj[:ambassador]
    raise 'Needs an Ambassador!' if @ambassador.nil?
    @@neighbor_count += 1
  end

  def ally?
    mood > 66
  end

  def neutral?
    33 <= mood && mood <= 66
  end

  def enemy?
    mood < 33
  end

  def relation
    case mood
      when (0...33)
        return :enemy
      when (33...66)
        return :neutral
      when (66..Status::MAX_MOOD)
        return :ally
      else
        return :neutral
    end
  end
end
