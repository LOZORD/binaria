class Decision
  attr_accessor :asker, :question, :yes, :no, :type, :is_decided
  def initialize (init_obj)
    @asker = init_obj[:asker]
    fail 'Decision needs an Advisor!'.red if @asker.nil?
    @type  = init_obj[:type]
    @question = init_obj[:question]
    @yes = init_obj[:yes]
    @no  = init_obj[:no]
    @is_decided = false
  end

  def ask
    fail 'Decision already decided!'.red if is_decided
    puts "#{ asker.name } asks:".yellow
    puts "\"#{ question }\""
    puts "Choosing #{ 'yes'.green }:".bold.blue
    yes.each do |k, v|
      print_result(k,v)
    end
    puts "\nChoosing #{ 'no'.red }:".bold.blue
    no.each do |k, v|
      print_result(k,v)
    end
  end

  def print_result (key, value)
    fail "Value `#{ value }` must be a number!".red unless value.is_a? Numeric
    v =
    if value >= 0
      ('+' + value.to_s).green
    else
      (value.to_s).red
    end

    puts "#{ nice_key(key).cyan }: #{ v }"
  end

  private
    def nice_key (key)
      key.to_s.split('_').map { |n| n.capitalize }.join(' ')
    end
end
