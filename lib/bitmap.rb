# Bitmap - creates, modifies and deletes a Bitmap representation.
#
# The +Bitmap+ is responsible for the creation of a Bitmap grid and
# handles any subsequent edits or deletions to the grid.
#
# The +Bitmap+ is indexed from 1. I. the top left pixel is [1,1]

class Bitmap

  class InvalidBitmapSize < StandardError
    def initialize
      super("The specified size is invalid. X and Y must both fall between #{MIN_SIZE} & #{MAX_SIZE} inclusively.")
    end
  end

  class OutOfBoundsError < StandardError
    def initialize(x, y, width, height)
      super("[#{x}, #{y}] is out of bounds. It must be within width 1 to #{width} and height 1 to #{height}")
    end
  end

  DEFAULT_FILL = "O"
  DEFAULT_SIZE = 6
  MIN_SIZE = 1
  MAX_SIZE = 250

  attr_reader :width, :height, :grid

  def initialize(width: DEFAULT_SIZE, height: DEFAULT_SIZE)
    @width = width
    @height = height

    raise InvalidBitmapSize.new unless valid_size?(@width, @height)
    @grid = Array.new(@height, DEFAULT_FILL) { Array.new(@width, DEFAULT_FILL) }
  end

  def show
    grid.each do |row|
      print "#{row} \n"
    end;nil
  end

  def clear
    grid.map! do |row|
      row.map! do |pixel|
        pixel = DEFAULT_FILL
      end
    end
  end

  #L X Y C - Colours the pixel (X,Y) with colour C.
  def color_pixel(x, y, color)
    # TODO: deal with invalid params passed.
    # TODO: avoid repeated calls .to_i.
    raise OutOfBoundsError.new(x.to_i, y.to_i, width, height) if out_of_bounds?(x.to_i, y.to_i)
    # TODO: Need to add -1 to deal with 1 indexing.
    # User passes 1,1. Pixel is represeted by grid[0][0]
    grid[y.to_i - 1][x.to_i - 1] = color
  end

  # V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
  def vertical_segment(x, y1, y2, color)
    #TODO - deal with invalid params etc.
    (y1..y2).to_a.each do |i|
      # Once again - 1 to deal with 1 indexing.
      grid[i - 1][x - 1] = color
    end
  end

  # H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
  def horiztonal_segment(x1, x2, y, color)
    #TODO - deal with invalid params etc.
    (x1..x2).to_a.each do |i|
      grid[y - 1][i - 1] = color
    end
  end

  private

  def valid_size?(width, height)
    (MIN_SIZE..MAX_SIZE).include?(width) && (MIN_SIZE..MAX_SIZE).include?(height)
  end

  #TODO: No need for true..
  def out_of_bounds?(x, y)
    true unless x.between?(0, width) && y.between?(0, height)
  end
end