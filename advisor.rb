class Advisor
  attr_accessor :name, :is_active, :mood, :decisions, :game
  def initialize (init_obj)
    @@advisor_count |= 1

    game = init_obj[:game] || throw NoGameException
    name = init_obj[:name] || 'Advisor' + @@advisor_count

    @@advisor_count += 1

    mood = Status::MAX_MOOD / 2

    decisions = []
  end
end
