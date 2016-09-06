# Executor - handles user input.
#
# The +Executor+ is responsible for handling user input
# and before passing calls to the Bitmap class.

class Executor

  class InvalidCommandCalled < StandardError
    def initialize(command)
      super("We don't recognise that command - you called #{command}. Try using ? to pull up the Help prompt")
    end
  end

  class CreateABitmapFirst < StandardError
    def initialize
      super("You don't seem to have created a Bitmap. Try using the command 'I 6 6'")
    end
  end

  attr_reader :bitmap

  CREATE_COMMAND = :I

  VALID_COMMANDS = {
    C: "clear",
    S: "show",
    L: "color_pixel",
    V: "vertical_segment",
    H: "horizontal_segment"
  }

  def execute(input)
    command, args = get_command(input), get_args(input)

    puts command
    puts args

    puts args[0]
    puts args[1]
    puts args[2]

    if VALID_COMMANDS[command]
      raise CreateABitmapFirst.new unless bitmap
      #otherwise still do something to the bitmap instance we are working with.
    elsif command == CREATE_COMMAND
      bitmap = args.empty? ? create_bitmap : create_bitmap(args[0].to_i, args[1].to_i)
    else
      raise InvalidCommandCalled.new(command)
    end
  end

  private

  # Strip to avoid any issues with leading whitespace.
  # to_sym to match hash keys.
  def get_command(input)
    input.strip[0].to_sym
  end

  # Working on a number of test cases - needs further testing.
  def get_args (input)
    input.gsub(/^[a-zA-Z\s+]/, " ").strip.split(" ")
  end

  def create_bitmap(width=nil, height=nil)
    @bitmap = width && height ? Bitmap.new(width: width, height: height) : Bitmap.new
  end


end