# The +Executor+ is responsible for handling user input
# and passing the user request to +Bitmap+
#
# Usage:
#   executor = Executor.new
#   executor.execute("I 1 1")

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
    input.strip[0].to_sym unless input.empty?
  end

  def get_args(input)
    input.strip.gsub(/^[a-zA-Z\s+]/, " ").split(" ")
  end

  def handle_bad_command(command)
    all_commands = VALID_COMMANDS.keys << CREATE_COMMAND

    if command.nil?
      raise NoInputGiven.new
    elsif all_commands.to_s.downcase.include?(command.to_s)
      raise DowncasedCommandCalled.new(command)
    else
      raise InvalidCommandCalled.new(command)
    end
  end

  def create_bitmap(width=nil, height=nil)
    @bitmap = width && height ? Bitmap.new(width: width, height: height) : Bitmap.new
  end
end