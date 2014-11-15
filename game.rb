# GAME CLASS
# IMPLEMENTS A SINGLE GAME
class Game
  ONE_MILLION = 1_000_000
  MAX_TAX = 100.0
  MAX_MOOD = 100.0
  def initialize
    @gold = @stone = @wood = ONE_MILLION
    @tax_rate = MAX_TAX / 10.0
    @holidays = []
    @other_states = []
    @serf_happiness = @lord_happiness = MAX_MOOD / 2
    @food = 5 * ONE_MILLION

    puts 'What is your name, Great Leader?'
    @player_name = gets.strip

    puts "Welcome to your kingdom #{@player_name}!"

    print_help
  end

  def play
    puts 'play time!'
  end

  def print_help
    puts 'hi, me is help text!'
  end
end
