class Decision
  attr_accessor :asker, :question, :yes, :no, :type, :is_decided
  def initialize (init_obj)
    @asker = init_obj[:asker]
    raise 'Decision needs an Advisor!' if @asker.nil?
    @type  = init_obj[:type]
    @question = init_obj[:question]
    @yes = init_obj[:yes]
    @no  = init_obj[:no]
    @is_decided = false
  end

  def ask
    raise 'Decision already decided!' if is_decided
    puts "#{ asker.name } asks:"
    puts "\"#{ question }\""
    puts 'Choosing yes:'
    yes.each do |k, v|
      sign = v >= 0 ? '+' : ''

      puts "#{ k }:#{ sign + v.to_s }"
    end
    puts 'Choosing no:'
    no.each do |k, v|
      sign = v >= 0 ? '+' : ''

      puts "#{ k }:#{ sign + v.to_s }"
    end
  end

  # TODO: make a method of the yes/no.each printing --> i.e. to_s
end
