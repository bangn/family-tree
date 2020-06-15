# frozen_string_literal: true

require "error"

class Presenter
  def self.present(command_result)
    case command_result[:command_type]
    when Command::ADD_CHILD
      return present_add_child_result(command_result)
    end
  end

  private

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
end
