class NeighborStatusChange < StatusChange
  attr_accessor :neighbor, :mood

  def initialize (init_obj)
    super(init_obj)
    @neighbor = init_obj[:neighbor]
    if @neighbor.nil?
      fail 'NeighborStatusChange must have an associated neighbor!'
    end
    @mood = init_obj[:mood]
  end

  def fields
    super << :mood
  end
end
