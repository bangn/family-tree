# frozen_string_literal: true

require "program/command"
require "relationship"

class Runner
  def self.run(command:, family:)
    command_arguments = command.arguments

    case command.type
    when Command::ADD_CHILD
      family.add_child(
        mother_name: command_arguments[0],
        child_name: command_arguments[1],
        gender: command_arguments[2],
      )
      { command_type: command.type, error: nil, output: nil }
    when Command::GET_RELATIONSHIP
      relationships = Relationship.get(
        name: command_arguments[0],
        relationship_type: command_arguments[1].upcase,
        family: family,
      )

      { command_type: command.type, error: nil, output: relationships }
    end
  rescue Error::ProgramError => e
    { command_type: command.type, error: e, output: nil }
  end
end
