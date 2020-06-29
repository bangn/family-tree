# frozen_string_literal: true

require "error"

class Presenter
  def self.present(command_result)
    case command_result[:command_type]
    when Command::ADD_CHILD
      present_add_child_result(command_result)
    when Command::GET_RELATIONSHIP
      present_get_relationship_result(command_result)
    end
  end

  def self.present_add_child_result(command_result)
    if command_result[:error].nil?
      return "CHILD_ADDITION_SUCCEED"
    end

    case command_result[:error]
    when Error::PersonNotFound
      "PERSON_NOT_FOUND"
    else
      "CHILD_ADDITION_FAILED"
    end
  end

  def self.present_get_relationship_result(command_result)
    if !command_result[:error].nil?
      return case command_result[:error]
             when Error::PersonNotFound
               "PERSON_NOT_FOUND"
             else
               "NONE"
             end
    end

    output = command_result[:output]

    return "NONE" if output.empty?

    output.map(&:name).join(" ")
  end
end
