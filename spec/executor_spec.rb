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

      it "paints a pixel successfully" do
        print subject.bitmap.grid
        expect(subject.bitmap.grid[0][0]).to eq "A"
      end

      context "when a bitmap has not been created already" do
        it "raises an error showing the user to create a bitmap before proceeding" do
          # TODO: Elaborate on the error
          expect { subject.execute("C") }.to raise_error
        end
      end
    end

    context "when the create action is called" do
      it "creates a new bitmap instance" do

      end
    end

    context "when a command that is not listed is called" do
      it "raises an error" do
        message = "We don't recognise that command - you called P. Try using ? to pull up the Help prompt"
        expect { subject.execute("P") }.to raise_error message
      end
    end
  end

end