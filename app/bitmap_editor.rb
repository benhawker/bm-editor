require_relative '../lib/bitmap'
require_relative '../lib/help'

class BitmapEditor

  def run
    @running = true
    puts 'type ? for help'
    while @running
      print '> '
      input = gets.chomp
      case input
        when '?'
          show_help
        when 'X'
          exit_console
        else
          puts 'unrecognised command :('
      end
    end
  end

  private

  def exit_console
    puts 'Goodbye!'
    @running = false
  end

  def show_help
    Help.show
  end
end