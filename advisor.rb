class Advisor
  attr_accessor :name, :is_active, :mood, :decisions, :game
  def initialize (init_obj)
    @@advisor_count ||= 1
    @game = init_obj[:game]
    fail 'Advisor needs to be linked to a game!'.red if @game.nil?
    @name = init_obj[:name] || 'Advisor' + @@advisor_count
    @@advisor_count += 1
    @mood = Status::MAX_MOOD / 2
    @decisions = build_decisions(init_obj[:decisions])
    fail 'Advisor needs Decisions!'.red if @decisions.nil? || @decisions.empty?
  end

  def build_decisions (decisions)
    decisions.map do |decision_hash|

      options = {
        asker:      self,
        type:       decision_hash[:type],
        question:   decision_hash[:question],
        yes:        decision_hash[:yes],
        no:         decision_hash[:no]
      }

      case decision_hash[:type].to_sym
      when :normal
        NormalDecision.new(options)
      when :diplomacy
        unless self.is_a? Ambassador
          fail 'Only Ambassadors can make diplomacy decisions!'.red
        end
        options[:neighbor] = self.nation
        DiplomacyDecision.new(options)
      when :holiday
        options[:holiday_name] = decision_hash[:holiday_name]
        HolidayDecision.new(options)
      when :project
        options[:project_name]      = decision_hash[:project_name]
        options[:days_to_complete]  = decision_hash[:days_to_complete]
        ProjectDecision.new(options)
      else
        fail "Unsupported Decision type `#{ decision_hash[:type] }` for regular Advisor!".red
      end
    end
  end
end
