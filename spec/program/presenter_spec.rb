# frozen_string_literal: true

require "faker"

require "models/person"
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

    context "when present #{Command::GET_RELATIONSHIP} result" do
      context "when succeeded" do
        context "when the person has such relationships" do
          let(:person_1) { Person.new(name: Faker::Name.first_name, gender: Gender::FEMALE) }
          let(:person_2) { Person.new(name: Faker::Name.first_name, gender: Gender::MALE) }

          it "joins those relationships" do
            command_result = {
              command_type: Command::GET_RELATIONSHIP,
              error: nil,
              output: [person_1, person_2],
            }

            expect(Presenter.present(command_result)).to eq("#{person_1.name} #{person_2.name}")
          end
        end

        context "when the person does not have such relationships" do
          it "returns NONE" do
            command_result = {
              command_type: Command::GET_RELATIONSHIP,
              error: nil,
              output: [],
            }

            expect(Presenter.present(command_result)).to eq("NONE")
          end
        end
      end

      context "when there is error" do
        context "when error is #{Error::PersonNotFound}" do
          it "outputs PERSON_NOT_FOUND" do
            command_result = {
              command_type: Command::GET_RELATIONSHIP,
              error: Error::PersonNotFound.new,
              output: nil,
            }

            expect(Presenter.present(command_result)).to eq("PERSON_NOT_FOUND")
          end
        end

        context "when different error" do
          it "outputs NONE" do
            command_result = {
              command_type: Command::GET_RELATIONSHIP,
              error: Error::NotSupportedRelationship,
              output: nil,
            }

            expect(Presenter.present(command_result)).to eq("NONE")
          end
        end
      end
    end
  end
end
