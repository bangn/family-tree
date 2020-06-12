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

  def self.get(relationship_type:, family:, name:)
    person = family.find(name: name)

    raise Error::PersonNotFound if person.nil?

    if !Relationship.supported_relationships.include?(relationship_type.upcase)
      raise Error::NotSupportedRelationship
    end

    case relationship_type.upcase
    when Relationship::DAUGHTER
      return daughters(person)
    when Relationship::SON
      return sons(person)
    when Relationship::SIBLINGS
      return siblings(person)
    else
      return []
    end
  end

  private

  def self.daughters(person)
    person.children.select { |child| child.gender == Gender::FEMALE }
  end

  def self.sons(person)
    person.children.select { |child| child.gender == Gender::MALE }
  end

  def self.siblings(person)
    person.mother&.children&.select { |child| child.name != person.name } || []
  end
end
