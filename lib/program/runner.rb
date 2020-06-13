# frozen_string_literal: true

require "program/command"
require "relationship"

class Runner
  def self.run(command:, family:)
    case command.type
    when Command::ADD_CHILD
      command_arguments = command.arguments

      family.add_child(
        mother_name: command_arguments[0],
        child_name: command_arguments[1],
        gender: command_arguments[2],
      )
      return { error: nil, output: nil }
    end
  rescue Error::PersonNotFound => error
    return { error: error, output: nil }
  end
end