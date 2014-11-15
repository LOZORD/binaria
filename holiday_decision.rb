class Holiday_Decision < Decision
  def initialize (init_obj)
    super(init_obj)
  end

  def decide! (choice, day)
    result = choice == :yes ? yes : no
    status = asker.game.status
    celebration = nil
    result.each do |prop, val|
      if prop.to_sym != :celebration &&
          status.responds_to? prop
        val += status.instance_variable_get(prop)
        status.instance_variable_set(prop, val)
      elsif prop.to_sym == :celebration
        celebration = val
      else
        throw BadPropertyException
      end
    end

    # TODO add new holiday

    is_decided = true
  end

end
