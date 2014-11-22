class Decision
  attr_accessor :asker, :question, :yes, :no, :type, :is_decided
  def initialize (init_obj)
    @asker = init_obj[:asker]
    raise 'Decision needs an Advisor!' if @asker.nil?
    @type  = init_obj[:type]
    @question = init_obj['question']
    @yes = init_obj['yes']
    @no  = init_obj['no']
    @is_decided = false
  end
end
