# GAME CLASS
# IMPLEMENTS A SINGLE GAME

require 'json'

class Game
  attr_accessor :day, :holidays, :neighbors, :advisors, :status, :rng, :player_name, :projects
  JSON_OPTS = { symbolize_names: true }
  TAXABLES  = [ :rock, :wood, :food ]
  def initialize
    @day = 0
    @holidays = Array.new(Holiday::DAYS_IN_YEAR) { Array.new }
    @projects = []
    @neighbors = build_neighbors
    @advisors = build_advisors
    @status = Status.new
    @rng = @status.rng
    print "What is your name, Great Leader?\n> "
    puts "Welcome to your kingdom #{@player_name = gets.strip}!"
  end

  def play
    print_help
    print '> '
    user_in = gets.chomp.downcase
    until user_in == 'quit'

      # first celebrate today's holidays
      puts "~~~ DAY #{ day + 1 } ~~~".white_on_blue
      puts "Calendar day #{ human_cal_day_today } of #{ Holiday::DAYS_IN_YEAR }".white_on_blue
      holidays[cal_day_today].each do |holiday|
        holiday.celebrate!
      end

      # taxes are collected every quarter
      if tax_day?
        collect_taxes!
      end

      # give an update on current projects
      unless projects.empty?
        puts "### PROJECTS (#{ projects.size }) ###".white_on_green
        # update all on-going projects
        projects.each { |project| project.update! }
        # removed completed projects
        projects.keep_if { |project| not project.complete? }
      end

      # print list of neighboring country relations (ally, enemy, neutral)
      if report_day?
        puts
        puts '== Your Master of Espionage reports the following on your neighbors =='.bold
        neighbors.each do |n|
          color = n.ally? ? :green : n.neutral? ? :yellow : :red
          puts "#{ n.name }: #{ n.relation }".send(color)
        end
        puts
      end

      # check if any end-game/losing conditions are satisfied
      if lost_game?
        puts "CONGRATULATIONS, YOU'VE RULED FOR #{ day } DAYS!"
        break
      end

      puts status.to_s

      todays_decisions = (advisors.map do |advisor|
        if rng.rand > 0.5 && !advisor.decisions.empty?
          advisor.decisions.shift
        end
      end).compact

      unless todays_decisions.empty?
        print "\nOh Powerful #{ player_name }, your advisors and ambassadors "
        print "come to you with #{ todays_decisions.size.to_s.bold } "
        if todays_decisions.size == 1
          puts 'decision'
        else
          puts 'decisions'
        end

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
          # get the next input
          print '> '
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
        puts '-- ' * 6
        puts
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

    neighbor_list.map! do |neighbor|
      neighbor_obj = { name: neighbor[:name], ambassador: neighbor[:ambassador] }
      Neighbor.new(neighbor_obj)
    end

    neighbor_list.sort { |a, b| a.name <=> b.name }
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

  def cal_day_today
    day % Holiday::DAYS_IN_YEAR
  end

  def human_cal_day_today
    (cal_day_today + 1).to_s
  end

  private
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
        enter in "yes" for Yes, and "no" for No.

      What could go wrong?

      (Press ENTER to continue)

      (Enter QUIT to leave the game)
      '''

      puts s
    end

    def lost_game?
      if status.gold <= 0
        puts """
          Sadly, you have depleted Binaria's gold reserves and treasury.

          As such, the common folk and your leal lords have risen up and
            remove you from your throne and removed your head from your body.
          """.red
        true
      elsif status.rock <= 0
        puts """
          Sadly, you have run out of rock with which to build.

          It actually wasn't so bad for a while. That was, until the
          sharknado came...
          """.red
        true
      elsif status.wood <= 0
        puts """
          Sadly, you've run out of wood.

          It might not seem like much. But your navy attempted to build ships
            with other things, like wood, mud, and goats.

          This was know as the Great Naval Blunder. You have been shamed
            off of your throne, only to be known as #{ player_name }, the Goat Boat Ruler.
        """.red
        true
      elsif status.food <= 0
        puts """
          Sadly, you've run out of food.

          Who knew that starving peasants could operate a guillotine so well?
       """.red
        true
      elsif status.serf_happiness <= 0
        puts """
          Sadly, you've pissed off your serfs. They really don't like you.

          Your PR team tried to help, but you really can't put a positive spin
            on the name \"#{ player_name } The Despicable\"
        """.red
        true
      elsif status.lord_happiness <= 0
        puts """
          Sadly, you've disgruntled your leal lords and ladies of Binaria.

          They did not take kindly to this. After a series of Machiavellian
            and dastardly plans, you've lost your claim to the throne.

          While this is terrible for you, the resulting books, TV shows, and
            films based on your fall has generated some income for Binaria
            (+5 gold). In addition, you've been given a fine
            job at the Binarian Antarctic Research Post cleaning test tubes!
        """.red
        true
      elsif neighbors.all? { |neighbor| neighbor.relation == :enemy }
        puts """
          Sadly, you angered all of your neighbors.

          They were always kind of dumb, but they still know how to make
            pointy sticks. They were also smart enough to rise up against
            you. You died a hero's death in your war room, playing with
            action figures. Your enemies only laughed a little bit.
        """.red
        true
      else
        false
      end
    end

    def tax_day?
      tax_period = Holiday::DAYS_IN_YEAR / 4

      cal_day_today % tax_period == tax_period - 1
    end

    # check fairness
    def collect_taxes!
      puts 'HAPPY QUARTERLY TAX DAY!'.green

      tax_amnt = TAXABLES.map { |item| status.get_with_sym(item) * self.status.tax_frac }.reduce(:+)

      no_tax = status.tax_rate.zero?

      tax_change_obj = {
        serf_happiness:  (no_tax ? 0 : -5),
        lord_happiness:  (no_tax ? 0 : -5),
        rock:            (-1 * status.rock * status.tax_frac).floor,
        wood:            (-1 * status.wood * status.tax_frac).floor,
        food:            (-1 * status.food * status.tax_frac).floor,
        gold:            (tax_amnt).floor
      }

      status.update_with_change(StatusChange.new tax_change_obj)
    end

    def report_day?
      cal_day_today % 7 == 6
    end
  # end private
end
