class Normal_Decision < Decision
  def initialize(init_obj)
    super(init_obj)
  end

  def decide!(choice)
    result = choice == :yes ? yes : no
    status = asker.game.status
    result.each do |prop, val|
      status.update(prop, val)
    end

    @is_decided = true
  end

  def print_result(key, value)
    super(key, value)
  end
end
