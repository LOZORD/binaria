class Neighbor
  attr_accessor :name, :status, :mood, :ambassador
  def initialize (init_obj)
    @@neighbor_count ||= 1
    @name = init_obj[:name] || 'Blargistan' + @@neighbor_count
    @mood = init_obj[:mood] || Status::MAX_MOOD / 2
    status_options = (init_obj[:status] || {}).merge({ owner: self })
    @status = Neighbor_Status.new(status_options)
    @ambassador  = init_obj[:ambassador]
    fail 'Needs an Ambassador!'.red if @ambassador.nil?
    @@neighbor_count += 1
  end

  def ally?
    relation == :ally
  end

  def neutral?
    relation == :neutral
  end

  def enemy?
    relation == :enemy
  end

  def relation
    case mood
      when (0...33)
        return :enemy
      when (33..66)
        return :neutral
      when (67..Status::MAX_MOOD)
        return :ally
      else
        return :neutral
    end
  end
end

