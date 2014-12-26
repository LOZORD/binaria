class Neighbor_Status < Status

  attr_accessor :owner, :mood

  def initialize (init_obj)
    @owner = init_obj[:owner]
    fail 'Neighbor Status must have an owner!'.red if @owner.nil?
    @mood = @owner.mood
    super(init_obj)
  end

end
