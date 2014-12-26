class Diplomacy_Decision < Decision
  attr_accessor :neighbor

  def initialize (init_obj)
    super init_obj
    @neighbor = asker.nation
    fail 'Needs a neighbor nation!'.red if @neighbor.nil?
    # refactor FIXME refactor
    @yes = {
      :binaria               => init_obj[:yes]['binaria'] || {},
      @neighbor.name.to_sym  => init_obj[:yes]['them']    || {}
    }
    @no  = {
      :binaria              => init_obj[:no]['binaria']   || {},
      @neighbor.name.to_sym => init_obj[:no]['them']      || {}
    }
  end

  def decide! (choice)
    result = choice == :yes ? yes : no

    game = asker.game
    binaria_status = game.status

    result[:binaria].each do |key, val|
      binaria_status.update(key, val)
    end

    result[@neighbor.name.to_sym].each do |key, val|
      @neighbor.status.update(key, val)
    end
  end

  def print_result (country_name, results)
    puts country_name.to_s.upcase.bold.magenta
    puts '-' * 10
    results.each { |k,v| super(k,v) }
    puts
  end
end
