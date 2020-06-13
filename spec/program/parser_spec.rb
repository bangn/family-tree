# frozen_string_literal: true

require "faker"

require "gender"
require "program/command"
require "program/parser"

RSpec.describe Parser do
  describe "#parse" do
    context "when the command is ADD_CHILD" do
      let(:mother_name) { Faker::Name.first_name }
      let(:child_name) { Faker::Name.first_name }
      let(:gender) { Gender::FEMALE }
      let(:input) { "#{Command::ADD_CHILD} #{mother_name} #{child_name} #{gender}" }

      it "returns new instance of Command class" do
        command = Parser.parse(input)

        expect(command.type).to eq("ADD_CHILD")
        expect(command.arguments).to eq([mother_name, child_name, gender])
      end
    end

    context "when the command is GET_RELATIONSHIP" do
      let(:mother_name) { Faker::Name.first_name }
      let(:child_name) { Faker::Name.first_name }
      let(:gender) { Gender::FEMALE }
      let(:input) { "#{Command::ADD_CHILD} #{mother_name} #{child_name} #{gender}" }

      it "returns new instance of Command class" do
        command = Parser.parse(input)

        expect(command.type).to eq("ADD_CHILD")
        expect(command.arguments).to eq([mother_name, child_name, gender])
      end
    end

    context "when the command is not suppported" do
      it "raises NotSupportedCommand error" do
        expect do
          Parser.parse("NOT_SUPPPORTED_COMMAND argument")
        end.to raise_error(Error::NotSupportedCommand)
      end
    end
  end
end
