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
end