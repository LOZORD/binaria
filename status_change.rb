class StatusChange

  attr_accessor :changes

  def initialize (init_obj)
    @changes = {}

    Status::RESOURCES.each do |resource|
      @changes[resource] = init_obj[resource] || 0
    end
  end

  def to_s
    changes.each { |k, v| print_result k, v }
  end

  def non_zero_changes
    changes.reject { |_, v| v.zero? }
  end

  def print_result (key, value)
    fail "Value `#{ value }` must be a number!".red unless value.is_a? Numeric
    v =
    if value >= 0
      ('+' + value.to_s).green
    else
      (value.to_s).red
    end

    puts "#{ nice_key(key).cyan }: #{ v }"
  end
end
