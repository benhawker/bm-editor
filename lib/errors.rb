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

class SegmentOutOfBoundsError < StandardError
  def initialize
    super("One or more of the pixels in this segment are out of bounds")
  end
end

class InvalidColorError < StandardError
  def initialize(color)
    super("#{color} is not a valid color - must be a capital letter A-Z")
  end
end

class ArgumentError < StandardError
  def initialize
    super("There seems to be an issue with the arguments you passed to this command. Try using ? to pull up the Help prompt")
  end
end

class NoInputGiven < StandardError
  def initialize
    super("Please provide some input!")
  end
end