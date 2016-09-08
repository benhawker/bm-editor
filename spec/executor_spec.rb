require "spec_helper"

RSpec.describe Executor do
  subject { described_class.new }

  describe "#execute" do
    # Listed in order that the if/elsif executes.

    context "valid commands - as per the specification" do
      let(:bitmap) { double(:bitmap) }

      before do
        subject.execute("I")
        subject.execute("L 1 1 A")
      end

      # Consider what we are testing - oversteps the responsibility of this class?
      # Test that it is sending the correct message to the Bitmap class rather than the below.
      it "paints a pixel successfully" do
        expect(subject.bitmap.grid[0][0]).to eq "A"
      end

      #TODO - refactor all of this.
      it "paints a pixel - repeated spec" do
        subject.stub(:bitmap).and_return(bitmap)

        expect(bitmap).to receive(:color_pixel).with("1", "1", "A")
        subject.execute("L 1 1 A")
      end

      context "when a bitmap has not been created already" do
        it "raises an error asking the user to create a bitmap before proceeding" do
          message = "You don't seem to have created a Bitmap. Create one using I."
          expect { described_class.new.execute("C") }.to raise_error (message)
        end
      end
    end

    # Double bitmap and expect it to receive the command specified...
    # Refactor the above context block to use this format.
    context "badly formatted commands - that are still valid" do

      let(:bitmap) { double(:bitmap) }

      before do
        subject.execute("I")
        subject.stub(:bitmap).and_return(bitmap)
      end

      it "accepts leading whitespace" do
        expect(bitmap).to receive(:color_pixel).with("1", "1", "A")
        # TODO: Failing on this test case. - L being passed as first arg.
        # L also being passed as command though.
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

    #TODO
    context "further context block for test separation" do
      let(:subject) { described_class.new }
      before(:each) { subject.execute("I 80 100") }

      it "creates a new bitmap instance of the specified size" do
        # Also check indexing
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
    end
  end

end