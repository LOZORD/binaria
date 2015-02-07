class Status
  ONE_MILLION = 1_000_000
  MAX_TAX = 100.0
  MAX_MOOD = 100.0
  RESOURCES = [:gold, :rock, :wood, :food, :tax_rate, :serf_happiness,
    :lord_happiness]
  RESOURCE_LIMITS = { gold: 0, rock: 0, wood: 0, food: 0,
    tax_rate: (0..MAX_TAX), serf_happiness: (0..MAX_MOOD),
    lord_happiness: (0..MAX_MOOD) }

  RESOURCES.each { |r| attr_accessor r }

  attr_accessor :rng

  def initialize (init_obj = {})
    @seed = init_obj[:seed] || Random.new_seed
    @rng = Random.new @seed
    @gold = init_obj[:gold] || ONE_MILLION
    @rock = init_obj[:rock] || ONE_MILLION
    @wood = init_obj[:wood] || ONE_MILLION
    @food = init_obj[:food] || ONE_MILLION
    @tax_rate = MAX_TAX / 10.0
    @serf_happiness = init_obj[:serf_happiness] || MAX_MOOD / 2
    @lord_happiness = init_obj[:lord_happiness] || MAX_MOOD / 2
  end

  def get_with_sym (some_sym)
    self.instance_variable_get(add_at_sign some_sym)
  end

  def tax_frac
    self.tax_rate/100
  end

  def to_s
    # XXX: figure out how to right align the RHS attr
    # solution: str.rjust(80), but do we still want to use this?
    RESOURCES.map do |item|
      "#{ item.to_s.upcase.bold.yellow }: #{ self.send(item).to_s.yellow }"
    end.join("\n")
  end

  def update_with_change (status_change)
    unless status_change.is_a? StatusChange
      fail "`update_with_change` must take a StatusChange object as the argument, got #{ status_change.class}".red
    end

    RESOURCES.each do |resource|
      update(resource, status_change.changes[resource])
    end
  end
  private
    def apply(some_attr, val)
      my_attr = prep_attr(some_attr)
      instance_variable_set(my_attr, val)
    end

    def update(some_attr, change_amnt)
      my_attr = prep_attr(some_attr)

      orig = instance_variable_get(my_attr)
      temp = orig + change_amnt

      limit = RESOURCE_LIMITS[rem_at_sign some_attr]

      val = nil

      if limit.is_a? Range
        val = temp.between?(limit.begin, limit.end) ? temp : orig
      elsif limit.is_a? Numeric
        val = temp
      else
        fail 'Bad limit for resource!'
      end

      apply(my_attr, val)
    end
    def prep_attr(some_attr)
      some_attr = add_at_sign some_attr

      unless self.instance_variable_defined?(some_attr)
        owner_name = ''
        if self.is_a? Neighbor_Status
          owner_name = self.owner.name
        else
          owner_name = 'YOU'
        end
        fail "Attribute `#{ some_attr }` does not exist for #{ owner_name }!".red
      end

      some_attr
    end

    def add_at_sign(some_attr)
      unless some_attr.to_s[0] == '@'
        some_attr = '@' + some_attr.to_s
      end
      some_attr.to_sym
    end

    def rem_at_sign(some_attr)
      if some_attr.to_s[0] == '@'
        some_attr = some_attr.to_s[1..-1]
      end
      some_attr.to_sym
    end
end
