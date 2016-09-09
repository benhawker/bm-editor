# +Interface+ provides the interface to handle user input.

require './lib/base'

class Prompt

  def run
    @running = true
    puts 'Type ? or help for Help'
    puts 'Type X, x or exit for Help'

    @executor = executor

    while @running
      print '> '
      input = gets.chomp

      case input
      when *help_cmd then show_help
      when *exit_cmd then exit_console
      else
        begin
          @executor.execute(input)
          puts "Command executed successfully. \n-------- "
        rescue StandardError => error
          puts "Failure. \n-------- "
          puts error.message
        end
      end

    end
  end

  private

  def exit_cmd
    ['X', 'x', 'exit']
  end

  def help_cmd
    ['?', 'help']
  end

  def executor
    Executor.new
  end

  def exit_console
    puts 'Goodbye!'
    @running = false
  end

  def show_help
    Help.show
  end
end