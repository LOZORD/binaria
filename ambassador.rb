class Ambassador < Advisor
  attr_accessor :nation

  def initialize (init_obj)
    @nation = init_obj[:nation]
    super(init_obj)
  end
end
