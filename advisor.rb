class Advisor
  attr_accessor :name, :is_active, :mood, :decisions, :game
  def initialize (init_obj)
    @@advisor_count ||= 1
    @game = init_obj[:game]
    raise ("Advisor needs to be linked to a game!") if @game.nil?
    @name = init_obj[:name] || 'Advisor' + @@advisor_count
    @@advisor_count += 1
    @mood = Status::MAX_MOOD / 2
    @decisions = build_decisions(init_obj[:decisions])
    raise 'Advisor needs Decisions!' if @decisions.nil? || @decisions.empty?
  end

  def build_decisions (decisions)
    decisions.map do |decision_hash|

      options = {
        asker:      self,
        type:       decision_hash['type'],
        question:   decision_hash['question'],
        yes:        decision_hash['yes'],
        no:         decision_hash['no']
      }

      case decision_hash['type'].to_sym
      when :normal
        Normal_Decision.new(options)
      when :diplomacy
        unless self.is_a? Ambassador
          raise 'Only Ambassadors can make diplomacy decisions!'
        end
        options[:neighbor] = self.nation
        Diplomacy_Decision.new(options)
      when :holiday
        options[:holiday_name] = decision_hash['holiday_name']
        Holiday_Decision.new(options)
      else
        raise "Unsupported Decision type `#{ decision_hash['type'] }` for regular Advisor!"
      end
    end
  end
end
