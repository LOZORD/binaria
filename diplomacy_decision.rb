class Diplomacy_Decision < Decision
  attr_accessor :neighbor

  def initialize (init_obj)
    super init_obj
    @neighbor = asker.nation || throw NoNeighborException
  end

  def decide! (choice)
    result = choice == :yes ? yes : no

    game = asker.game
    binaria_status = game.status

    result[:binaria].each do |prop, val|
      binaria_status.update(prop, val)
    end

    result[:them].each do |prop, val|
      asker.nation.status.update(prop, val)
    end
  end
end
