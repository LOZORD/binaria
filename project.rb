class Project
  attr_accessor :name, :days_to_completion, :daily_status, :game, :completion_status

  def initialize(init_obj)
    @@project_count ||= 1
    @name = init_obj[:name] || 'Project #' + @@project_count.to_s
    @game = init_obj[:game]
    fail 'A Project needs to be associated with a Game!' unless @game
    @daily_status = init_obj[:status] || Status.new
    @completion_status = init_obj[:completion_status] || Status.new
    @days_to_completion = init_obj[:days_to_completion] || 5
    @@project_count += 1
  end

  def complete?
    days_to_completion == 0
  end

  def update!
    days_to_complete -= 1
    if self.complete?
      # TODO message
        game.status.apply @completetion_status
      # self = nil
    else
      # TODO message
      game.status.apply @daily_status
    end
  end
end