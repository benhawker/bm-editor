# Bitmap - creates, modifies and deletes a Bitmap representation.
#
# The +Bitmap+ is responsible for the creation of a Bitmap grid and
# handles any subsequent edits or deletions to the grid.
#
# The +Bitmap+ is indexed from 1. I. the top left pixel is [1,1]

class Bitmap
  attr_reader :width, :height, :grid

  #TODO: Validate that color must be a CAPITAL LETTER A-Z

  DEFAULT_FILL = "O"
  DEFAULT_SIZE = 6
  MIN_SIZE = 1
  MAX_SIZE = 250

  def initialize(width: DEFAULT_SIZE, height: DEFAULT_SIZE)
    @width = width
    @height = height

    raise InvalidBitmapSize.new unless valid_size?(@width, @height)
    @grid = Array.new(@height) { Array.new(@width) { DEFAULT_FILL } }
  end

  def show
    grid.each do |row|
      print "#{row} \n"
    end
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
    # TODO: avoid repeated calls .to_i. Consider passing parameters already in correct type.
    # Requirements for a params coverter/sanitizer class?
    raise OutOfBoundsError.new(x.to_i, y.to_i, width, height) unless pixel_valid?(x.to_i, y.to_i)
    # TODO: Need to add -1 to deal with 1 indexing.
    # User passes 1,1. Pixel is represeted by grid[0][0]
    grid[y.to_i - 1][x.to_i - 1] = color
  end

  # V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
  def vertical_segment(x, y1, y2, color)
    #TODO - deal with invalid params etc.
    raise SegmentOutOfBoundsError.new unless vertical_segment_valid?(x.to_i, y1.to_i, y2.to_i)

    (y1..y2).to_a.each do |i|
      # Once again - 1 to deal with 1 indexing.
      grid[i.to_i - 1][x.to_i - 1] = color
    end
  end

  # H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
  def horizontal_segment(x1, x2, y, color)
    #TODO - deal with invalid params etc.
    raise SegmentOutOfBoundsError.new unless horizontal_segment_valid?(x1.to_i, x2.to_i, y.to_i)

    (x1..x2).to_a.each do |i|
      grid[y.to_i - 1][i.to_i - 1] = color
    end
  end

  private

  def valid_size?(width, height)
    (MIN_SIZE..MAX_SIZE).include?(width) && (MIN_SIZE..MAX_SIZE).include?(height)
  end

  def pixel_valid?(x, y)
    x.between?(0, width) && y.between?(0, height)
  end

  #TODO - Refactor into common method? Possible?
  def vertical_segment_valid?(x, y1, y2)
    (y1..y2).each do |y|
      return false unless pixel_valid?(x, y)
    end
  end

  def horizontal_segment_valid?(x1, x2, y)
    (x1..x2).each do |x|
      return false unless pixel_valid?(x, y)
    end
  end
end