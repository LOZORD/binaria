class Normal_Decision < Decision
  def initialize (init_obj)
    super(init_obj)
  end

  def decide! (choice)
    result = choice == :yes ? yes : no
    status = asker.game.status
    result.each do |prop, val|
      if status.responds_to? prop
        val += status.instance_variable_get(prop)
        status.instance_variable_set(prop, val)
      else
        raise "Status #{status} has no corresponding property '#{prop}'"
      end
    end

    is_decided = true
  end
end
