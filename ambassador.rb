class Ambassador < Advisor
  attr_accessor :nation

  def initialize (n)
    nation = n
  end
end
