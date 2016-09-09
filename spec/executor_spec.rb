require "spec_helper"

RSpec.describe Executor do
  subject { described_class.new }
  let(:bitmap) { double(:bitmap) }

  describe "#execute" do
    context "valid commands - as per the specification" do

      before do
        subject.execute("I")
        subject.execute("L 1 1 A")
      end

      class BitmapDouble
        def color_pixel(*args); @args = args; end
        def args; @args; end
      end

      it "paints a pixel" do
        bitmap_double = BitmapDouble.new
        subject.stub(:bitmap).and_return(bitmap_double)
        subject.execute("L 1 1 A")
        expect(bitmap_double.args).to eq(["1", "1", "A"])
      end

      context "when a bitmap has not been created already" do
        it "raises an error asking the user to create a bitmap before proceeding" do
          message = "You don't seem to have created a Bitmap. Create one using I."
          expect { described_class.new.execute("C") }.to raise_error (message)
        end
      end
    end

    context "badly formatted commands - that are still valid" do
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
      let(:subject) { described_class.new }
      before(:each) { subject.execute("I") }

      it "creates a new bitmap instance of the default size when called with no arguments" do
        # This should be creating a 6 x 6 grid. Zero indexed this should be 0..5 - needs further work.
        expect(subject.bitmap.grid.size).to eq 6
        expect(subject.bitmap.grid[rand(0...6)].size).to eq 6
      end
    end

    context "further context block for test separation" do
      let(:subject) { described_class.new }
      before { subject.execute("I 80 100") }

      it "creates a new bitmap instance of the specified size" do
        # TODO: Check indexing
        expect(subject.bitmap.grid.size).to eq 100
        expect(subject.bitmap.grid[rand(0...100)].size).to eq 80
      end

      it "creates a new bitmap instance even if we have one already created (essentially overwriting)" do
        subject.execute("I 2 2")
        expect(subject.bitmap.grid.size).to eq 2
      end
    end

    context "when a command that is not listed is called" do
      it "raises an error" do
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