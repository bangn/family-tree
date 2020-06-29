# frozen_string_literal: true

require "error"

class Command
  attr_reader :type, :arguments

  ADD_CHILD = "ADD_CHILD"
  GET_RELATIONSHIP = "GET_RELATIONSHIP"

  def initialize(type:, arguments:)
    raise Error::NotSupportedCommand unless Command.support?(type.upcase)

    @arguments = arguments
    @type = type
  end

  def self.support?(type)
    constants.map(&:to_s).include?(type.upcase)
  end
end
