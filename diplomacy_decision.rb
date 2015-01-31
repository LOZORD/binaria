class DiplomacyDecision < Decision
  attr_accessor :neighbor

  def initialize (init_obj)
    super init_obj
    @neighbor = asker.nation
    fail 'Needs a neighbor nation!'.red if @neighbor.nil?
    init_obj[:yes][:them][:neighbor]=init_obj[:no][:them][:neighbor]=@neighbor
    @yes = {
      :binaria        => StatusChange.new(init_obj[:yes][:binaria]),
      neighbor_sym    => NeighborStatusChange.new(init_obj[:yes][:them])
    }
    @no  = {
      :binaria        => StatusChange.new(init_obj[:no][:binaria]),
      neighbor_sym    => NeighborStatusChange.new(init_obj[:no][:them])
    }
  end

  def ask
    fail 'Decision already decided!'.red if is_decided

    puts "#{ asker.name } asks:".yellow
    puts "\"#{ question }\""

    puts "Choosing #{ 'yes'.green }:".bold.blue
    print_result(:binaria, yes[:binaria])
    print_result(neighbor_sym, yes[neighbor_sym])

    puts "\nChoosing #{ 'no'.red }:".bold.blue
    print_result(:binaria, no[:binaria])
    print_result(neighbor_sym, no[neighbor_sym])
  end

  def decide! (choice)
    result = choice == :yes ? yes : no

    game = asker.game
    binaria_status = game.status

    binaria_status.update_with_change(result[:binaria])
    neighbor.status.update_with_change(result[neighbor_sym])

    @is_decided = true
  end

  def print_result (country_name, results)
    puts country_name.to_s.upcase.bold.magenta
    puts '-' * 10
    results.non_zero_changes.each { |k,v| super(k,v) }
    puts
  end

  def neighbor_sym
    neighbor.name.to_sym
  end
end
