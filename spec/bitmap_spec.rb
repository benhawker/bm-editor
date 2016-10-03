require "spec_helper"

RSpec.describe Bitmap do
  let(:width) { 5 }
  let(:height) { 5 }
  subject { described_class.new(width: width, height: height) }

  describe "constructor" do
    context "when a width and height is passed to initialize" do
      it "creates a bitmap grid of the specified size" do
        expect(subject.grid.size).to eq 5
        expect(subject.grid[0].size).to eq 5
      end

      let(:message) { "The specified size is invalid. X and Y must both fall between #{Bitmap::MIN_SIZE} & #{Bitmap::MAX_SIZE} inclusively." }

      it "raises an error when the width is larger than allowed" do
        expect { described_class.new(width: 251, height: 1) }.to raise_error (message)
      end

      it "raises an error when the height is larger than allowed" do
        expect { described_class.new(width: 1, height: 251) }.to raise_error (message)
      end

      it "raises an error should the user try to specify a zero height or width" do
        expect { described_class.new(width: 1, height: 0) }.to raise_error (message)
      end
    end

    context "when no width or height is passed to initialize" do
      it "defaults to the default sizes if no width or height is passed" do
        subject = described_class.new
        expect(subject.grid[rand(1..height-1)]).to contain_exactly("O", "O", "O", "O", "O", "O")
      end
    end

    it "defaults to the colour to the default fill of 0" do
      expect(subject.grid[rand(1..height-1)]).to contain_exactly("O", "O", "O", "O", "O")
    end
  end

  describe "#show" do
    it "outputs the grid on a row by row basis in the console" do
      grid_output = "    1    2    3    4    5\n1 [\"O\", \"O\", \"O\", \"O\", \"O\"] \n2 [\"O\", \"O\", \"O\", \"O\", \"O\"] \n3 [\"O\", \"O\", \"O\", \"O\", \"O\"] \n4 [\"O\", \"O\", \"O\", \"O\", \"O\"] \n5 [\"O\", \"O\", \"O\", \"O\", \"O\"] \n"
      expect { subject.show }.to output(grid_output).to_stdout
    end
  end

  describe "#clear" do
    before do
      subject.color_pixel(1, 1, "A")
      subject.color_pixel(1, 2, "B")
    end

    it "resets all the pixels to the default fill `O`" do
      expect(subject.grid[0][0]).to eq "A"
      expect(subject.grid[1][0]).to eq "B"

      subject.clear

      expect(subject.grid[1][1]).to eq "O"
      expect(subject.grid[3][1]).to eq "O"
    end
  end

  describe "#color_pixel" do
    before do
      subject.color_pixel(1, 1, "A")
      subject.color_pixel(3, 1, "B")
    end

    it "colors the expected pixel" do
      expect(subject.grid[0][0]).to eq "A"
      expect(subject.grid[0][2]).to eq "B"
    end

    it "does not color any other pixels" do
      expect(subject.grid[0][1]).to eq "O"
      expect(subject.grid[3][2]).to eq "O"
    end

    it "raises an error if the specified pixel is out of bounds" do
      message = "[7, 1] is out of bounds. It must be within width 1 to 5 and height 1 to 5"
      expect { subject.color_pixel(7, 1, "A") }.to raise_error (message)
    end

    it "raises an error if the color is not A-Z" do
      message = "a is not a valid color - must be a capital letter A-Z"
      expect { subject.color_pixel(7, 1, "a") }.to raise_error (message)
    end
  end

  # (x, y1, y2, color)
  describe "#vertical_segment" do
    before do
      subject.clear
      subject.vertical_segment(1, 2, 4, "A")
    end

    it "colors the expected vertical segement" do
      1.upto(3) do |i|
        expect(subject.grid[i][0]).to eq "A"
      end
    end

    it "does not color any other pixels" do
      0.upto(4) do |x|
        1.upto(4) do |y|
          expect(subject.grid[x][y]).to eq "O"
        end
      end
    end

    it "raises an error if any of the specified pixels are out of bounds" do
      message = "One or more of the pixels in this segment are out of bounds"
      expect { subject.vertical_segment(100, 1, 2, "A") }.to raise_error (message)
    end

    it "raises an error if the color is not A-Z" do
      message = "x is not a valid color - must be a capital letter A-Z"
      expect { subject.vertical_segment(100, 1, 2, "x") }.to raise_error (message)
    end
  end

  # (x1, x2, y, color)
  describe "#horizontal_segment" do
    before do
      subject.horizontal_segment(1, 4, 1, "A")
    end

    it "colors the expected horizontal_segment" do
      0.upto(3) do |i|
        expect(subject.grid[0][i]).to eq "A"
      end
    end

    it "does not color any other pixels" do
      0.upto(4) do |x|
        1.upto(4) do |y|
          expect(subject.grid[y][x]).to eq "O"
        end
      end
      expect(subject.grid[0][4]).to eq "O"
    end

    describe "#fill_neighbouring" do
      before do
        subject.clear

        1.upto(5).each do |i|
          subject.horizontal_segment(1, 5, i, "A")
        end

        subject.color_pixel(1, 1, "B")
        subject.color_pixel(2, 1, "B")
        subject.color_pixel(3, 1, "B")
        subject.color_pixel(1, 2, "B")
      end

      it "fills the neighbouring cells that are of the same original colour" do
        subject.fill_neighbouring(1, 1, "C")
        expect(subject.grid[0][0]).to eq "C"
        expect(subject.grid[0][1]).to eq "C"
        expect(subject.grid[1][0]).to eq "C"
        expect(subject.grid[0][2]).to eq "C"

        # Expect all others to remain as A
        expect(subject.grid[2][1]).to eq "A"
        expect(subject.grid[1][1]).to eq "A"
      end

      context "a further spec" do
        before do
          subject.clear

          1.upto(5).each do |i|
            subject.horizontal_segment(1, 5, i, "A")
          end

          subject.color_pixel(5, 5, "B")
          subject.color_pixel(5, 4, "B")
          subject.color_pixel(5, 3, "B")
          subject.color_pixel(5, 2, "B")
          subject.color_pixel(5, 1, "B")
        end

        it "fills the neighbouring cells that are of the same original colour (2nd spec)" do
          subject.fill_neighbouring(5, 4, "C")
          expect(subject.grid[4][4]).to eq "C"
          expect(subject.grid[3][4]).to eq "C"
          expect(subject.grid[2][4]).to eq "C"
          expect(subject.grid[1][4]).to eq "C"
          expect(subject.grid[0][4]).to eq "C"

          # Expect all others to remain as A - this test could be more rigorous.
          expect(subject.grid[2][1]).to eq "A"
          expect(subject.grid[1][1]).to eq "A"
        end
      end

      context "a further further spec" do
        before do
          subject.clear

          1.upto(5).each do |i|
            subject.horizontal_segment(1, 5, i, "A")
          end

          subject.color_pixel(5, 5, "B")
          subject.color_pixel(5, 4, "B")
          subject.color_pixel(5, 3, "B")
          subject.color_pixel(5, 2, "B")
          subject.color_pixel(5, 1, "B")
        end

        it "fills the neighbouring cells that are of the same original colour (3rd spec)" do
          subject.fill_neighbouring(5, 1, "C")
          expect(subject.grid[0][4]).to eq "C"
          expect(subject.grid[1][4]).to eq "C"
          expect(subject.grid[2][4]).to eq "C"
          expect(subject.grid[3][4]).to eq "C"
          expect(subject.grid[4][4]).to eq "C"

          # Expect all others to remain as A - this test should be more rigorous.
          expect(subject.grid[2][1]).to eq "A"
          expect(subject.grid[1][1]).to eq "A"
        end
      end
    end

    it "raises an error if the color is not A-Z" do
      message = "1 is not a valid color - must be a capital letter A-Z"
      expect { subject.vertical_segment(100, 1, 2, 1) }.to raise_error (message)
    end
  end
end