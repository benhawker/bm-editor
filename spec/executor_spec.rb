require "spec_helper"

RSpec.describe Executor do

  describe "#execute" do
    context "when a command that is not listed is called" do
      it "raises an error" do
        message = "We don't recognise that command - you called P. Try using ? to pull up the Help prompt"
        expect { subject.execute("P") }.to raise_error message
      end
    end

    context "when the create action is called" do
      it "creates a new bitmap instance" do

      end
    end
  end

end