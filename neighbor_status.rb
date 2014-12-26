class Neighbor_Status < Status

  attr_accessor :owner, :mood

  def initialize (init_obj)
    @owner = init_obj[:owner]
    raise 'Neighbor Status must have an owner!' if @owner.nil?
    @mood = @owner.mood
    super(init_obj)
  end

end
