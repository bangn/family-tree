# frozen_string_literal: true

class Gender
  MALE = "MALE"
  FEMALE = "FEMALE"

  def self.supported_genders
    constants.map(&:to_s)
  end
end
