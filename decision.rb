class Decision
  attr_accessor :asker, :question, :yes, :no, :type, :is_decided
  def initialize (init_obj)
    @asker = init_obj[:asker]
    fail 'Decision needs an Advisor!'.red if @asker.nil?
    @type  = init_obj[:type]
    @question = init_obj[:question]
    @yes = StatusChange.new(init_obj[:yes])
    @no  = StatusChange.new(init_obj[:no])
    @is_decided = false
  end

  def ask
    fail 'Decision already decided!'.red if is_decided
    puts "#{ asker.name } asks:".yellow
    puts "\"#{ question }\""
    display_consequences
  end

  def print_result (key, value)
    fail "Value `#{ value }` must be a number!".red unless value.is_a? Numeric
    v =
    if value > 0
      ('+' + value.to_s).green
    elsif value < 0
      (value.to_s).red
    else
      (value.to_s).yellow
    end

    puts "#{ nice_key(key).cyan }: #{ v }"
  end

  def display_consequences
    puts "Choosing #{ 'yes'.green }:".bold.blue
    yes.non_zero_changes.each do |k, v|
      print_result(k,v)
    end
    puts "\nChoosing #{ 'no'.red }:".bold.blue
    no.non_zero_changes.each do |k, v|
      print_result(k,v)
    end
  end

  private
    def nice_key (key)
      key.to_s.split('_').map { |n| n.capitalize }.join(' ')
    end
end
