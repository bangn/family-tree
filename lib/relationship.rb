# frozen_string_literal: true

class Relationship
  # Father's brothers
  PATERNAL_UNCLE = "PATERNAL-UNCLE"

  # Mother's brothers
  MATERNAL_UNCLE = "MATERNAL-UNCLE"

  # Father's sisters
  PATERNAL_AUNT = "PATERNAL-AUNT"

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

    case relationship_type.upcase
    when DAUGHTER
      return daughters(person)
    when SON
      return sons(person)
    when SIBLINGS
      return siblings(person)
    when PATERNAL_UNCLE
      return paternal_uncles(person)
    when MATERNAL_UNCLE
      return maternal_uncles(person)
    when PATERNAL_AUNT
      return paternal_aunts(person)
    when MATERNAL_AUNT
      return maternal_aunts(person)
    else
      raise Error::NotSupportedRelationship
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

  def self.paternal_uncles(person)
    father = person.mother&.spouse

    return [] if father.nil?

    siblings(father).select do |person|
      person.gender == Gender::MALE && person.name != father.name
    end
  end

  def self.maternal_uncles(person)
    return [] if person.mother.nil?

    siblings(person.mother).select { |person| person.gender == Gender::MALE && person.name }
  end

  def self.paternal_aunts(person)
    father = person.mother&.spouse

    return [] if father.nil?

    siblings(father).select { |person| person.gender == Gender::FEMALE }
  end

  def self.maternal_aunts(person)
    mother = person.mother

    return [] if mother.nil?

    siblings(mother).select { |person| person.gender == Gender::FEMALE }
  end
end
