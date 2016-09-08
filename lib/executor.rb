# The +Executor+ is responsible for handling user input
# and passing the user request to +Bitmap+
#
# Usage:
#   executor = Executor.new
#   executor.execute("I 10 10")

class Executor
  CREATE_COMMAND = :I

  VALID_COMMANDS = {
    C: "clear",
    S: "show",
    L: "color_pixel",
    V: "vertical_segment",
    H: "horizontal_segment"
  }

  attr_reader :bitmap

  def execute(input)
    command, args = get_command(input), get_args(input)

    ## _____ ##
    # puts "executor obj"
    # puts self

    # puts "bitmap"
    # puts bitmap

    # puts "Command"
    # puts command

    # puts "Args 1-3"
    # puts args[0]
    # puts args[1]
    # puts args[2]
    # puts args[3]
    ## _____ ##

    if VALID_COMMANDS[command]
      raise CreateABitmapFirst.new unless bitmap
      self.bitmap.public_send(VALID_COMMANDS[command], *args)
    elsif command == CREATE_COMMAND
      args.empty? ? create_bitmap : create_bitmap(args[0].to_i, args[1].to_i)
    else
      handle_bad_command(command)
    end
  end

  private

  def get_command(input)
    input.strip[0].to_sym
  end

  def get_args(input)
    input.strip.gsub(/^[a-zA-Z\s+]/, " ").split(" ")
  end

  def handle_bad_command(command)
    all_commands = VALID_COMMANDS.keys << CREATE_COMMAND

    if all_commands.to_s.downcase.include?(command.to_s)
      raise DowncasedCommandCalled.new(command)
    else
      raise InvalidCommandCalled.new(command)
    end
  end

  def create_bitmap(width=nil, height=nil)
    @bitmap = width && height ? Bitmap.new(width: width, height: height) : Bitmap.new
  end
end