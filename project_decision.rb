class ProjectDecision < Decision
  attr_accessor :project_name, :days_to_completion
  def initialize (init_obj)
    super(init_obj)
    @project_name     = init_obj[:project_name]
    @days_to_completion = init_obj[:days_to_completion]
  end

  def decide! (choice)
    if choice == :yes
      # first create a new project to add to the game
      arg_data = {
        name: @project_name,
        game: self.game,
        daily_status:       StatusChange.new(yes[:daily_status]),
        completion_status:  StatusChange.new(yes[:completion_status]),
        days_to_completion: @days_to_completion
      }

      new_proj = Project.new arg_data

      puts "Work will commence on Project '#{ new_proj.name }' tomorrow, my liege!"
      asker.game.projects << new_proj
    else
      puts 'The proposed project will not happen'.red
      asker.game.status.update_with_change StatusChange.new(no)
    end
  end

end
