# frozen_string_literal: true

require "error"
require "program/command"

class Parser
  def self.parse(string)
    command_and_arguments = string.strip.split(" ")

    command_type = command_and_arguments.first.upcase
    command_arguments = command_and_arguments[1..]

    raise Error::NotSupportedCommand unless Command.support?(command_type)

    Command.new(type: command_type, arguments: command_arguments)
  end
end
