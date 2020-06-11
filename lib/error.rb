# frozen_string_literal: true

class Error
  class NotSupportedGender < StandardError; end
  class PersonNotFound < StandardError; end
  class InappropriateMotherGender < StandardError; end
end
