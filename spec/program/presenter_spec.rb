# frozen_string_literal: true

require "program/command"
require "program/presenter"

RSpec.describe Presenter do
  describe "#present" do
    context "when present #{Command::ADD_CHILD} result" do
      context "when succeeded" do
        it "outputs CHILD_ADDITION_SUCCEED" do
          command_result = {
            command_type: Command::ADD_CHILD,
            error: nil,
            output: nil,
          }

          expect(Presenter.present(command_result)).to eq("CHILD_ADDITION_SUCCEED")
        end
      end

      context "when there is error" do
        context "when error is #{Error::PersonNotFound}" do
          it "outputs PERSON_NOT_FOUND" do
            command_result = {
              command_type: Command::ADD_CHILD,
              error: Error::PersonNotFound.new,
              output: nil,
            }

            expect(Presenter.present(command_result)).to eq("PERSON_NOT_FOUND")
          end
        end

        context "when different error" do
          it "outputs CHILD_ADDITION_FAILED" do
            command_result = {
              command_type: Command::ADD_CHILD,
              error: "failed",
              output: nil,
            }

            expect(Presenter.present(command_result)).to eq("CHILD_ADDITION_FAILED")
          end
        end
      end
    end
  end
end
