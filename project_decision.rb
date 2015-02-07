class ProjectDecision < Decision
  attr_accessor :project_name, :days_to_completion
  def initialize (init_obj)
    super(init_obj)

    @project_name       = init_obj[:project_name]
    @days_to_completion = init_obj[:days_to_completion]

    fail 'Project needs day amount!' if @days_to_completion.nil? || @days_to_completion.zero?

    daily_changes = init_obj[:yes][:daily_status]
    compl_changes = init_obj[:yes][:completion_status]

    @yes                = {
      daily_status:       StatusChange.new(daily_changes),
      completion_status:  StatusChange.new(compl_changes)
    }
  end

  def decide! (choice)
    if choice == :yes
      # first create a new project to add to the game

      arg_data = {
        name: @project_name,
        game: asker.game,
        daily_status:       yes[:daily_status],
        completion_status:  yes[:completion_status],
        days_to_completion: @days_to_completion
      }

      new_proj = Project.new arg_data

      asker.game.projects << new_proj
    else
      asker.game.status.update_with_change StatusChange.new(no)
    end
  end

  def display_consequences
    puts "Choosing #{ 'yes'.green }:".bold.blue
    puts "Every day for #{ days_to_completion } days:"
    yes[:daily_status].non_zero_changes.each do |k, v|
      print_result(k,v)
    end
    puts 'And at completion:'
    yes[:completion_status].non_zero_changes.each do |k, v|
      print_result(k,v)
    end
    puts "\nChoosing #{ 'no'.red }:".bold.blue
    no.non_zero_changes.each do |k, v|
      print_result(k,v)
    end
  end

end
