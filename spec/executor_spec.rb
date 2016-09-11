require "spec_helper"

RSpec.describe Executor do
  subject { described_class.new }
  let(:bitmap) { double(:bitmap) }

  describe "#execute" do
    context "when a bitmap has not been created already" do
      it "raises an error asking the user to create a bitmap before proceeding" do
        message = "You don't seem to have created a Bitmap. Create one using I."
        expect { described_class.new.execute("C") }.to raise_error (message)
      end
    end

    context "valid commands - as per the specification" do
      before do
        subject.execute("I")
        subject.execute("L 1 1 A")
        subject.stub(:bitmap).and_return(bitmap)
      end

      it "paints a pixel" do
        expect(bitmap).to receive(:color_pixel).with("1", "1", "A")
        subject.execute("L 1 1 A")
      end

      it "paints a horizontal segment (x1, x2, y, color)" do
        expect(bitmap).to receive(:horizontal_segment).with("1", "6", "4", "A")
        subject.execute("H 1 6 4 A")
      end

      it "paints a vertical segment(x, y1, y2, color)" do
        expect(bitmap).to receive(:vertical_segment).with("1", "1", "4", "X")
        subject.execute("V 1 1 4 X")
      end

      it "clears the bitmap" do
        expect(bitmap).to receive(:clear)
        subject.execute("C")
      end

      it "shows the bitmap" do
        expect(bitmap).to receive(:show)
        subject.execute("S")
      end

      it "paint a diagonal segment" do
        expect(bitmap).to receive(:diagonal_segment).with("1", "5", "5", "1", "X")
        subject.execute("D 1 5 5 1 X")
      end
    end

    context "valid command - that are badly formatted" do
      before do
        subject.execute("I")
        subject.stub(:bitmap).and_return(bitmap)
      end

      it "accepts leading whitespace" do
        expect(bitmap).to receive(:color_pixel).with("1", "1", "A")
        subject.execute("   L 1 1 A")
      end

      it "accepts trailing whitespace" do
        expect(bitmap).to receive(:color_pixel).with("1", "1", "A")
        subject.execute("L 1 1 A    ")
      end

      it "accepts additional whitespace between the command and parameters" do
        expect(bitmap).to receive(:color_pixel).with("1", "1", "A")
        subject.execute("L   1 1 A")
      end

      it "accepts additional whitespace between each parameter" do
        expect(bitmap).to receive(:color_pixel).with("1", "1", "A")
        subject.execute("L 1   1       A")
      end
    end

    context "when the create action is called" do
      it "creates a new bitmap instance" do
        expect(Bitmap).to receive(:new).with ({:width=>5, :height=>5})
        subject.execute("I 5 5")
      end

      it "creates a new bitmap instance even if one is already created" do
        original_bitmap_object_id = subject.bitmap.object_id
        subject.execute("I 2 2")
        expect(subject.bitmap.object_id).not_to eq (original_bitmap_object_id)
      end
    end

    context "when a command that is not listed is called" do
      it "raises an error when the command is not recognised" do
        message = "We don't recognise that command - you called P. Try using ? to pull up the Help prompt"
        expect { subject.execute("P") }.to raise_error (message)
      end

      it "raises an error when no input is given" do
        message = "Please provide some input!"
        expect { subject.execute("") }.to raise_error (message)
      end

      it "raises an error with a suggestion when calling a valid command but with lower case" do
        message = "The command letter is valid but we only accept capital letters. Call I."
        expect { subject.execute("i") }.to raise_error (message)
      end
    end
  end
end