class Status
  ONE_MILLION = 1_000_000
  MAX_TAX = 100.0
  MAX_MOOD = 100.0
  attr_accessor :rng, :gold, :rock, :wood, :tax_rate, :serf_happiness,
    :lord_happiness, :food
  def initialize (init_obj = {})
    @seed = init_obj[:seed] || Random.new_seed
    @rng = Random.new seed
    @gold = init_obj[:gold] || ONE_MILLION
    @rock = init_obj[:rock] || ONE_MILLION
    @wood = init_obj[:wood] || ONE_MILLION
    @food = init_obj[:food] || ONE_MILLION * 5
    @tax_rate = MAX_TAX / 10.0
    @serf_happiness = init_obj[:serf_happiness] || MAX_MOOD / 2
    @lord_happiness = init_obj[:lord_happiness] || MAX_MOOD / 2
  end
end
