# GAME CLASS
# IMPLEMENTS A SINGLE GAME

require 'json'

class Game
  attr_accessor :day, :holidays, :neighbors, :advisors, :status, :rng
  def initialize
    @day = 1
    @holidays = Array.new(Holiday::DAYS_IN_YEAR) { Array.new }
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
    # FIXME
    until user_in == 'QUIT'

      # first celebrate today's holidays
      cal_day_today = day % Holiday::DAYS_IN_YEAR
      holidays[cal_day_today].each do |holiday|
        holiday.celebrate!
      end

      todays_decisions = advisors.map do |advisor|
        if rng.rand > 0.5
          advisor.decisions.shift
        else
          nil
        end
      end.compact

      # TODO something with decisions
      their_decision = ''

      ctr = 0

      while user_in == "\n"
        if ctr < todays_decisions.size
          some_decision = todays_decisions[ctr]
          ctr += 1
          some_decision.ask
        else
          if todays_decisions.size == 0
            puts 'No decisions today'
          else
            puts 'No more decisions today'
          end
        end
        user_in = gets.chomp
      end

      if user_in.upcase! == 'QUIT'
        break
      elsif user_in == 'YES' || user_in == 'Y'
        their_decision = :yes
      else
        their_decision = :no
      end

      if their_decision
        todays_decisions.each { |decision| decision.decide! their_decision }
      else
        puts 'NEED A DECISION' # FIXME
      end

      @day += 1
    end

    puts 'GAME OVER'
  end


  def build_neighbors
    json = File.read('neighbors.json')
    neighbor_list = JSON.parse(json)['neighbors']

    neighbor_list.map do |neighbor|
      neighbor_obj = { name: neighbor['name'], ambassador: neighbor['ambassador'] }
      Neighbor.new(neighbor_obj)
    end
  end

  def build_advisors
    json = File.read('advisors.json')

    advisor_list = JSON.parse(json)['advisors']

    advisor_list.map do |advisor|
      neighbor_index = @neighbors.index { |neighbor| neighbor.ambassador == advisor['name'] }
      if neighbor_index
        Ambassador.new ( { name: advisor['name'],
          decisions: advisor['decisions'],
          nation: @neighbors[neighbor_index],
          game: self } )
      else
        Advisor.new ( { name: advisor['name'],
          decisions: advisor['decisions'],
          game: self } )
      end
    end
  end

  def print_help
    s = '''
    After disembowling the previous ruler, the lords and ladies of Binaria
     have chosen you as the new Arbiter of justice and goodwill!

    Although your new job will be pretty sweet, you do have to make tough
     decisions. Every day, advisors and ambassadors will visit you. We know
     you\'re more of the fighting type, so now all decisions in Binaria are
     simple Yes or No questions. Pretty easy right?

    We\'ve also made your job easier by making each decision an Official
     Decree. This means that all you need to do is say Yes or No to one
     question, and the same answer applies to all of the others.

    Press <Enter> to forward through your visitors\' jibber-jabber.
    When you are ready to make your Official Decree,
     enter in "yes" for Yes, and "no" for No".

    What could go wrong?

    (Enter QUIT to leave the game)
    '''

    puts s
  end
end
