class StatusChange
  attr_accessor :gold, :rock, :wood, :tax_rate, :serf_happiness,
    :lord_happiness, :food

  def initialize (init_obj)
    @gold = init_obj[:gold] || 0
    @rock = init_obj[:rock] || 0
    @wood = init_obj[:wood] || 0
    @food = init_obj[:food] || 0
    @tax_rate = init_obj[:tax_rate] || 0
    @serf_happiness = init_obj[:serf_happiness] || 0
    @lord_happiness = init_obj[:lord_happiness] || 0
  end

  def fields
    [:gold, :rock, :rock, :tax_rate, :serf_happiness, :lord_happiness]
  end

  def live_fields
    fields.map { |field| self.instance_variable_get(field) }
  end

  def updated_fields
    live_fields.delete_if { |field| field.nil? || field.zero? }
  end

  def empty?
    updated_fields.empty?
  end
end
