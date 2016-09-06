# Bitmap - creates, modifies and deletes a Bitmap representation.
#
# The +Bitmap+ is responsible for the creation of a Bitmap grid and
# handles any subsequent edits or deletions to the grid.
#
# The +Bitmap+ is indexed from 1. I. the top left pixel is [1,1]

class Bitmap
  DEFAULT_FILL = "O"
  DEFAULT_SIZE = 6
  MIN_SIZE = 1
  MAX_SIZE = 250

  attr_reader :width, :height, :grid

  def initialize(width: DEFAULT_SIZE, height: DEFAULT_SIZE)
    @width = width
    @height = height

    @grid = Array.new(@height, DEFAULT_FILL) { Array.new(@width, DEFAULT_FILL) }
  end
end