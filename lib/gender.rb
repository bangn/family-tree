# frozen_string_literal: true

class Gender
  MALE = "male"
  FEMALE = "female"

  def self.supported_genders
    constants.map(&:to_s).map(&:downcase)
  end
end
