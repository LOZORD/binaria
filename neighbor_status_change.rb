class NeighborStatusChange < StatusChange
  attr_accessor :neighbor

  def initialize (init_obj)
    super(init_obj)
    @neighbor = init_obj[:neighbor]
    if @neighbor.nil?
      fail 'NeighborStatusChange must have an associated neighbor!'
    end
    @changes[:mood] = init_obj[:mood] || 0
  end

  def print_result (country_name, results)
    puts country_name.to_s.upcase.bold.magenta
    puts '-' * 10
    results.each { |k,v| super(k,v) }
    puts
  end
end
