class Decision
  attr_accessor :asker, :question, :yes, :no, :type, :is_decided
  # TODO do something with type!
  def initialize (init_obj)
    @asker = init_obj[:asker] || throw NoAdvisorException
    @question = init_obj['question']
    @yes = init_obj['yes']
    @no  = init_obj['no']
    @is_decided = false
  end
end
