require "spec_helper"

RSpec.describe Executor do
  subject { described_class.new }

  describe "#execute" do
    # Listed in order that the if/elsif executes.

    context "when a valid command is called" do
      before do
        subject.execute("I")
        subject.execute("L 1 1 A")
      end

      # Consider what we are testing - oversteps the responsibility of this class?
      # Test that it is sending the correct message to the Bitmap class rather than the below.
      it "paints a pixel successfully" do
        print subject.bitmap.grid
        expect(subject.bitmap.grid[0][0]).to eq "A"
      end

      context "when a bitmap has not been created already" do
        it "raises an error asking the user to create a bitmap before proceeding" do
          message = "You don't seem to have created a Bitmap. Create one using I."
          expect { described_class.new.execute("C") }.to raise_error (message)
        end
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