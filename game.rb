# GAME CLASS
# IMPLEMENTS A SINGLE GAME

require 'json'

class Game
  attr_accessor :day, :holidays, :neighbors, :advisors, :status, :rng, :player_name, :projects
  JSON_OPTS = { symbolize_names: true }
  def initialize
    @day = 0
    @holidays = Array.new(Holiday::DAYS_IN_YEAR) { Array.new }
    @projects = []
    @neighbors = build_neighbors
    @advisors = build_advisors
    @status = Status.new
    @rng = @status.rng
    puts 'What is your name, Great Leader?'
    puts "Welcome to your kingdom #{@player_name = gets.strip}!"
  end

  def play
    print_help
    user_in = gets.chomp
    until user_in == 'QUIT'

      # first celebrate today's holidays
      puts "~~~ DAY #{ day + 1 } ~~~".white_on_blue
      puts "Calendar day #{ human_cal_day_today } of #{ Holiday::DAYS_IN_YEAR }".white_on_blue
      holidays[cal_day_today].each do |holiday|
        holiday.celebrate!
      end
      # TODO: add a daily consumption/update (randomized?)
      # print the status of the Binarian nation afterwards
      # SOLUTION: use Projects as daily changes!
      unless projects.empty?
        puts "### PROJECTS (#{ projects.size }) ###".white_on_green
        projects.each do |project|
          project.update!
        end

        @projects = @projects.compact
      end

      # TODO: check if any end-game/losing conditions are satisfied

      puts status.to_s

      ### TODO print list of neighboring country relations (ally, enemy, neutral)

      todays_decisions = (advisors.map do |advisor|
        if rng.rand > 0.5 && !advisor.decisions.empty?
          advisor.decisions.shift
        end
      end).compact

      unless todays_decisions.empty?
        puts ("\nOh Powerful #{ player_name }, your advisors and ambassadors come to you with #{ todays_decisions.size.to_s.bold } decisions today!\n")

        their_decision = ''

        ctr = 0

        user_in = "\n"

        while user_in == "\n"
          if ctr < todays_decisions.size
            some_decision = todays_decisions[ctr]
            some_decision.ask
            ctr += 1
          else
            if todays_decisions.size == 0
              puts 'No decisions today'
            else
              puts 'No more decisions today'
            end
          end
          user_in = gets
        end

        if user_in.chomp!.upcase! == 'QUIT'
          break
        elsif user_in == 'YES' || user_in == 'Y'
          their_decision = :yes
          colorized = :green_on_white
        else
          their_decision = :no
          colorized = :red_on_white
        end

        puts '-*- In Summary -*-'

        todays_decisions.each do |decision|
          decision.decide! their_decision
          puts "#{ decision.asker.name.bold }:\t#{ decision.question }"
          puts "\t#{ (' ' + their_decision.to_s.upcase + ' ').send(colorized) }"
        end
      else
        puts "No decisions need to be made today #{ player_name }...".bold.black
      end
      @day += 1
    end
    puts 'GAME OVER'
  end


  def build_neighbors
    json = File.read('neighbors.json')
    neighbor_list = JSON.parse(json, JSON_OPTS)[:neighbors]

    neighbor_list.map do |neighbor|
      neighbor_obj = { name: neighbor[:name], ambassador: neighbor[:ambassador] }
      Neighbor.new(neighbor_obj)
    end
  end

  def build_advisors
    json = File.read('advisors.json')

    advisor_list = JSON.parse(json, JSON_OPTS)[:advisors]

    advisor_list.map do |advisor|
      neighbor_index = @neighbors.index { |neighbor| neighbor.ambassador == advisor[:name] }
      if neighbor_index
        Ambassador.new({
          name: advisor[:name],
          decisions: advisor[:decisions],
          nation: @neighbors[neighbor_index],
          game: self
        })
      else
        Advisor.new({
          name: advisor[:name],
          decisions: advisor[:decisions],
          game: self
        })
      end
    end
  end

  def print_help
    s = '''
    After disembowling the previous ruler, the lords and ladies of Binaria
      have chosen you as the new arbiter of justice and goodwill!

    Although your new job will be pretty sweet, you do have to make tough
      decisions. Every day, advisors and ambassadors will visit you. We know
      you\'re more of the fighting type, so we\'ll keep things simple.

    As is the custom, decisions in Binaria are simple Yes or No questions.

    Pretty easy right?

    We\'ve also made your job easier by making each decision an Official
      Decree. This means that all you need to do is say Yes or No to one
      question, and the same answer applies to all of the others.

    Press <Enter> to forward through your visitors\' jibber-jabber.

    When you are ready to make your Official Decree,
      enter in "yes" for Yes, and "no" for No".

    What could go wrong?

    (Press ENTER to continue)

    (Enter QUIT to leave the game)
    '''

    puts s
  end

  def cal_day_today
    day % Holiday::DAYS_IN_YEAR
  end

  def human_cal_day_today
    (cal_day_today + 1).to_s
  end
end
