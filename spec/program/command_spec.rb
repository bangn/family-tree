# frozen_string_literal: true

require "program/command"

RSpec.describe Command do
  describe ".initialize" do
    it "assigns command type and arguments to its instance" do
      command = Command.new(type: "ADD_CHILD", arguments: ["mother-name", "child-name", "male"])

      expect(command.type).to eq("ADD_CHILD")
      expect(command.arguments).to eq(["mother-name", "child-name", "male"])
    end

    context "when the command is not suppported" do
      it "raises NotSupportedCommand error" do
        expect do
          Command.new(type: "NOT_SUPPPORTED_COMMAND", arguments: ["argument"])
        end.to raise_error(Error::NotSupportedCommand)
      end
    end
  end

  describe "#support?" do
    ["ADD_CHILD", "GET_RELATIONSHIP"].each do |supported_type|
      context "when command type is #{supported_type}" do
        it "returns true" do
          expect(Command.support?(supported_type)).to be true
        end
      end
    end

    context "when command type is not supported" do
      it "returns false" do
        expect(Command.support?("does_not_suppport_type")).to be false
      end
    end
  end
end
