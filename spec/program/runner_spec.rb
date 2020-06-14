# frozen_string_literal: true

require "program/runner"
require_relative "../fixtures/king_shan_family"

RSpec.describe Runner do
  let(:king_shan_family) { KingShanFamily.create }

  describe "#run" do
    context "when adding new child" do
      context "when succeed" do
        it "returns result and its output" do
          command = Command.new(type: Command::ADD_CHILD, arguments: ["Anga", "Agna", Gender::FEMALE])
          result = Runner.run(command: command, family: king_shan_family)

          expect(result[:command_type]).to eq(Command::ADD_CHILD)
          expect(result[:error]).to be(nil)
          expect(result[:output]).to be(nil)
        end
      end

      context "when error" do
        context "when there is no such mother name in the family" do
          it "returns PersonNotFound error" do
            command = Command.new(type: Command::ADD_CHILD, arguments: ["no_name", "Agna", Gender::FEMALE])
            result = Runner.run(command: command, family: king_shan_family)

            expect(result[:command_type]).to eq(Command::ADD_CHILD)
            expect(result[:error]).to be_a(Error::PersonNotFound)
            expect(result[:output]).to be(nil)
          end
        end

        context "when the child was added through a father" do
          it "returns InappropriateMotherGender error" do
            command = Command.new(type: Command::ADD_CHILD, arguments: ["Shan", "Nahs", Gender::FEMALE])
            result = Runner.run(command: command, family: king_shan_family)

            expect(result[:command_type]).to eq(Command::ADD_CHILD)
            expect(result[:error]).to be_a(Error::InappropriateMotherGender)
            expect(result[:output]).to be(nil)
          end
        end

        context "when the child's gender is not suppported" do
          it "returns InappropriateMotherGender error" do
            command = Command.new(type: Command::ADD_CHILD, arguments: ["Anga", "Nahs", "unknown_gender"])
            result = Runner.run(command: command, family: king_shan_family)

            expect(result[:command_type]).to eq(Command::ADD_CHILD)
            expect(result[:error]).to be_a(Error::NotSupportedGender)
            expect(result[:output]).to be(nil)
          end
        end
      end
    end
  end
end
