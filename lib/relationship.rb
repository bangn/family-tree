# frozen_string_literal: true

class Relationship
  # Father's brothers
  PATERNAL_UNCLE = "PATERNAL-UNCLE"

  # Mother's brothers
  MATERNAL_UNCLE = "MATERNAL-UNCLE"

  # Father's sisters
  PARTERNAL_AUNT = "MATERNAL-AUNT"

  # Mother's sisters
  MATERNAL_AUNT = "MATERNAL-AUNT"

  # Spouse's sisters, wives of siblings
  SISTER_IN_LAW = "SISTER-IN-LAW"

  # Spouse's brothers, husband of siblings
  BROTHER_IN_LAW = "BROTHER-IN-LAW"

  SON = "SON"
  DAUGHTER = "DAUGHTER"
  SIBLINGS = "SIBLINGS"

  def self.supported_relationships
    constants.map(&:to_s)
  end
end
