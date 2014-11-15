# GAME CLASS
# IMPLEMENTS A SINGLE GAME

require_relative 'status.rb'
require 'json'

class Game
  def initialize
    @day = 1
    @holidays = []
    @neighbors = build_neighbors
    @advisors = build_advisors

    puts 'What is your name, Great Leader?'
    puts "Welcome to your kingdom #{@player_name = gets.strip}!"
  end

  def play
    puts 'play time!'

    print_help
  end


  def build_neighbors
    json = File.read('neighbors.json')
    neighbor_list = JSON.parse(json)['neighbors']

    neighbor_list.map do |neighbor|
      Neighbor.new(neighbor['name'], neighbor['ambassador'])
    end
  end

  def build_advisors
    json = File.read('advisors.json')

    advisor_list = JSON.parse(json)['advisors']

    advisor_list.map do |advisor|
      neighbor_index = @neighbors.index { |neighbor| neighbor.ambassador == advisor['name'] }
      if neighbor_index
        Ambassador.new ( { name: advisor['name'], decisions: advisor['decisions'], nation: @neighbors[neighbor_index] } )
      else
        Advisor.new ( { name: advisor['name'], decisions: advisor['decisions'] } )
      end
    end
  end

  def print_help
    s = "Welcome to your reign #{@player_name}!\n"
    s += '''
    After disembowling the previous ruler, the lords and ladies of Binaria
     have chosen you as the new Arbiter of justice and goodwill!\n

    Although your new job will be pretty sweet, you do have to make tough
     decisions. Every day, advisors and ambassadors will visit you. We know
     you\'re more of the fighting type, so now all decisions in Binaria are
     simple Yes or No questions. Pretty easy right?\n

    We\'ve also made your job easier by making each decision an Official
     Decree. This means that all you need to do is say Yes or No to one
     question, and the same answer applies to all of the others.

    Press <Enter> to forward through your visitors\' jibber-jabber.
    When you are ready to make your Official Decree,
     enter in "yes" for Yes, and "no" for No".

    What could go wrong?
    '''

    puts s
  end
end
