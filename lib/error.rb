# frozen_string_literal: true

class Error
  class InappropriateMotherGender < StandardError; end
  class NotSupportedCommand < StandardError; end
  class NotSupportedGender < StandardError; end
  class NotSupportedRelationship < StandardError; end
  class PersonNotFound < StandardError; end
end
