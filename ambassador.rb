class Ambassador < Advisor
  attr_accessor :nation

  def initialize (init_obj)
    super(init_obj)
    @nation = init_obj[:nation]
  end
end
