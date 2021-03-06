# Bitmap - creates, modifies and deletes a Bitmap representation.
#
# N.B: The +Bitmap+ is indexed from 1. I. the top left pixel is [1,1]
#
# Usage:
#   bitmap = Bitmap.new(10, 10)
#   bitmap.show

class Bitmap
  attr_reader :width, :height, :grid

  DEFAULT_FILL = "O".freeze
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

  # Example: F X Y C
  # Colours horizontally or vertically adjacent cells if they are the same colour as the one being targeted.
  def fill_neighbouring(x, y, color)
    # tmp var to store the original color of the targeted pixel
    original_color = grid[y.to_i - 1][x.to_i - 1]

    # Color the original pixel as a starting point
    color_pixel(x, y, color)

    # Find all neighbours that match the original color
    find_neighbours(x.to_i - 1, y.to_i - 1, original_color, color)
  end

  private

  def find_neighbours(x, y, original_color, color)
    adjacent_coords = [
                        { x: x + 1, y: y }, { x: x - 1, y: y },
                        { x: x, y: y + 1 }, { x: x, y: y - 1 }
                      ]

    adjacent_coords.each do |coords|
      if valid_coords?(coords[:x], coords[:y]) && grid[coords[:y]][coords[:x]] == original_color
        # Color the pixel
        color_pixel(coords[:x] + 1, coords[:y] + 1, color)

        # Continue searching for further neighbours
        find_neighbours(coords[:x], coords[:y], original_color, color)
      end
    end
  end

  def valid_coords?(x, y)
    x.between?(0, width - 1) && y.between?(0, height - 1)
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
    (y1..y2).all? { |y| pixel_valid?(x,y) }
  end

  def horizontal_segment_valid?(x1, x2, y)
    (x1..x2).all? { |x| pixel_valid?(x,y) }
  end
end