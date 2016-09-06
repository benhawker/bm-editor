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