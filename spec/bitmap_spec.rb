require "spec_helper"

RSpec.describe Bitmap do
  let(:width) { 5 }
  let(:height) { 5 }
  subject { described_class.new(width: width, height: height) }

  describe "#initialize" do
    context "when a width and height is passed to initialize" do
      it "creates a bitmap grid of the specified size" do
        expect(subject.grid.size).to eq 5
        expect(subject.grid[0].size).to eq 5
      end

      it "raises an error when the width is larger than allowed" do
        expect { described_class.new(width: 251, height: 1) }.to raise_error("The specified size is invalid. X and Y must both fall between #{Bitmap::MIN_SIZE} & #{Bitmap::MAX_SIZE} inclusively.")
      end

      it "raises an error when the height is larger than allowed" do
        expect { described_class.new(width: 1, height: 251) }.to raise_error("The specified size is invalid. X and Y must both fall between #{Bitmap::MIN_SIZE} & #{Bitmap::MAX_SIZE} inclusively.")
      end

      it "raises an error should the user try to specify a zero height or width" do
        expect { described_class.new(width: 1, height: 0) }.to raise_error("The specified size is invalid. X and Y must both fall between #{Bitmap::MIN_SIZE} & #{Bitmap::MAX_SIZE} inclusively.")
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
      #TODO - testing STDOUT.
    end

    it "outputs the grid 250 x 250 size" do
      #TODO - testing STDOUT.
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
  end

  # (x1, x2, y, color)
  describe "#horiztonal_segment" do
    before do
      subject.horiztonal_segment(1, 4, 1, "A")
    end

    it "colors the expected horiztonal_segment" do
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
  end
end