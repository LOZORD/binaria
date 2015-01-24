class Status
  ONE_MILLION = 1_000_000
  MAX_TAX = 100.0
  MAX_MOOD = 100.0
  attr_accessor :rng, :gold, :rock, :wood, :tax_rate, :serf_happiness,
    :lord_happiness, :food
  def initialize (init_obj = {})
    @seed = init_obj[:seed] || Random.new_seed
    @rng = Random.new @seed
    @gold = init_obj[:gold] || ONE_MILLION
    @rock = init_obj[:rock] || ONE_MILLION
    @wood = init_obj[:wood] || ONE_MILLION
    @food = init_obj[:food] || ONE_MILLION * 5
    @tax_rate = MAX_TAX / 10.0
    @serf_happiness = init_obj[:serf_happiness] || MAX_MOOD / 2
    @lord_happiness = init_obj[:lord_happiness] || MAX_MOOD / 2
  end


  def to_s
    # TODO: figure out how to right align the RHS attr
    printables.map do |item|
      "#{ item.to_s.upcase.bold.yellow }: #{ self.send(item).to_s.yellow }"
    end.join("\n")
  end

  def apply(some_attr, val)
    my_attr = prep_attr(some_attr)
    instance_variable_set(my_attr, val)
  end

  def update(some_attr, change_amnt)
    my_attr = prep_attr(some_attr)

    temp = instance_variable_get(my_attr) + change_amnt
    apply(my_attr, temp)
  end
  private
    def prep_attr(some_attr)
      unless some_attr.to_s[0] == '@'
        some_attr = '@' + some_attr.to_s
      end

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

    def printables
      [:gold, :rock, :wood, :food, :tax_rate, :serf_happiness, :lord_happiness]
    end
end
