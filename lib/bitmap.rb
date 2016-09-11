# Bitmap - creates, modifies and deletes a Bitmap representation.
#
# N.B: The +Bitmap+ is indexed from 1. I. the top left pixel is [1,1]
#
# Usage:
#   bitmap = Bitmap.new(10, 10)
#   bitmap.show

class Bitmap
  attr_reader :width, :height, :grid

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

  # Show the grid in the terminal.
  def show
    1.upto(width).each { |x| print "    " + "#{x}"}
    print "\n"

    grid.each_with_index do |row, index|
      print "#{index + 1} #{row} \n"
    end
  end

  # Clears the grid. Returning all pixels to the default fill.
  def clear
    grid.map do |row|
      row.map! do |pixel|
        pixel = DEFAULT_FILL
      end
    end
  end

  # Example: L X Y C
  # Colours the pixel (X,Y) with colour C.
  def color_pixel(x, y, color)
    raise InvalidColorError.new(color) unless valid_color?(color)
    raise OutOfBoundsError.new(x.to_i, y.to_i, width, height) unless pixel_valid?(x.to_i, y.to_i)

    grid[y.to_i - 1][x.to_i - 1] = color
  end

  # Example: V X Y1 Y2 C
  # Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
  def vertical_segment(x, y1, y2, color)
    raise InvalidColorError.new(color) unless valid_color?(color)
    raise SegmentOutOfBoundsError.new unless vertical_segment_valid?(x.to_i, y1.to_i, y2.to_i)

    y1.upto(y2).each do |i|
      grid[i.to_i - 1][x.to_i - 1] = color
    end
  end

  # Example: H X1 X2 Y C
  # Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
  def horizontal_segment(x1, x2, y, color)
    raise InvalidColorError.new(color) unless valid_color?(color)
    raise SegmentOutOfBoundsError.new unless horizontal_segment_valid?(x1.to_i, x2.to_i, y.to_i)

    x1.upto(x2).each do |i|
      grid[y.to_i - 1][i.to_i - 1] = color
    end
  end

  # Example: D 1 1 6 6 C
  # Draw a diagonal segment of colour C from 1,1 to 6,6
  def diagonal_segment(x1, y1, x2, y2, color)
    if x2 < x1
      x1, x2 = x2, x1
      y1, y2 = y2, y1
    end

    coords_to_fill = build_coords(x1, y1, x2, y2)

    print coords_to_fill

    coords_to_fill.each do |coord|
      color_pixel(coord[0], coord[1], color)
    end
  end

  private

  def build_coords(x1, y1, x2, y2)
    coords = []

    x1.upto(x2).each { |x| coords << [x] }

    y1.upto(y2).each_with_index do |y, y_index|
      coords.each_with_index do |el, coords_index|
        el << y if y_index == coords_index
      end
    end
    coords
  end

  def valid_size?(width, height)
    (MIN_SIZE..MAX_SIZE).include?(width) && (MIN_SIZE..MAX_SIZE).include?(height)
  end

  def valid_color?(color)
    [*('A'..'Z')].include?(color)
  end

  def pixel_valid?(x, y)
    x.between?(0, width) && y.between?(0, height)
  end

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