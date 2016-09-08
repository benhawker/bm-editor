require_relative './bitmap'
require_relative './executor'
require_relative './help'

# Errors related to Executor class
class InvalidCommandCalled < StandardError
  def initialize(command)
    super("We don't recognise that command - you called #{command}. Try using ? to pull up the Help prompt")
  end
end

class DowncasedCommandCalled < StandardError
  def initialize(command)
    super("The command letter is valid but we only accept capital letters. Call #{command.upcase}.")
  end
end

class CreateABitmapFirst < StandardError
  def initialize
    super("You don't seem to have created a Bitmap. Create one using I.")
  end
end

# Errors related to Bitmap class
class InvalidBitmapSize < StandardError
  def initialize
    super("The specified size is invalid. X and Y must both fall between #{Bitmap::MIN_SIZE} & #{Bitmap::MAX_SIZE} inclusively.")
  end
end

class OutOfBoundsError < StandardError
  def initialize(x, y, width, height)
    super("[#{x}, #{y}] is out of bounds. It must be within width 1 to #{width} and height 1 to #{height}")
  end
end

#TODO - Further details required here.
class SegmentOutOfBoundsError < StandardError
  def initialize
    super("Segment out of bounds - to be specified")
  end
end
