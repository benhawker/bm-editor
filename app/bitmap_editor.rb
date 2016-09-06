require_relative '../lib/bitmap'
require_relative '../lib/executor'
require_relative '../lib/help'

class BitmapEditor

  def run
    @running = true
    puts 'Type ? for Help'
    while @running
      print '> '
      input = gets.chomp

      case input
      when '?'
        show_help
      when 'X'
        exit_console
      else
        executor.execute(input)
      end
    end
  end

  private

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