class NormalDecision < Decision
  def initialize(init_obj)
    super(init_obj)
  end

  def decide!(choice)
    result = choice == :yes ? yes : no
    status = asker.game.status
    status.update_with_change result

    @is_decided = true
  end

  def print_result(key, value)
    super(key, value)
  end
end
