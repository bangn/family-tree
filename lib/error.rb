# frozen_string_literal: true

module Error
  class ProgramError < StandardError; end

  class InappropriateMotherGender < ProgramError; end
  class NotSupportedCommand < ProgramError; end
  class NotSupportedGender < ProgramError; end
  class NotSupportedRelationship < ProgramError; end
  class PersonNotFound < ProgramError; end
end
