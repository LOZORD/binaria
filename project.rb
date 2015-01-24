class Project
  attr_accessor :name, :days_to_completion, :daily_status, :game, :completion_status

  def initialize(init_obj)
    @@project_count ||= 1
    @name = init_obj[:name] || 'Project #' + @@project_count.to_s
    @game = init_obj[:game]
    fail 'A Project needs to be associated with a Game!' unless @game
    @daily_status = init_obj[:daily_status] || StatusChange.new
    @completion_status = init_obj[:completion_status] || StatusChange.new
    @days_to_completion = init_obj[:days_to_completion] || 5
    @@project_count += 1
  end

  def complete?
    days_to_completion == 0
  end

  def update!
    days_to_completion -= 1
    if self.complete?
      puts "PROJECT #{ name }: COMPLETE!".bold.magenta
      # FIXME --> an object needs to be made
      fail 'create StatusChange obj!'.bold.cyan
      game.status.apply @completetion_status
    else
      puts "PROJECT #{ name }: #{ days_to_completion } days until complete"
      game.status.apply @daily_status
    end
  end
end
