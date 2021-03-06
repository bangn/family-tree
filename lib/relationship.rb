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
      daughters(person)
    when SON
      sons(person)
    when SIBLINGS
      siblings(person)
    when PATERNAL_UNCLE
      paternal_uncles(person)
    when MATERNAL_UNCLE
      maternal_uncles(person)
    when PATERNAL_AUNT
      paternal_aunts(person)
    when MATERNAL_AUNT
      maternal_aunts(person)
    when SISTER_IN_LAW
      sisters_in_law(person)
    when BROTHER_IN_LAW
      brothers_in_law(person)
    else
      raise Error::NotSupportedRelationship
    end
  end

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

    siblings(father).select do |father_sibling|
      father_sibling.gender == Gender::MALE && father_sibling.name != father.name
    end
  end

  def self.maternal_uncles(person)
    return [] if person.mother.nil?

    siblings(person.mother).select { |sibling| sibling.gender == Gender::MALE && sibling.name }
  end

  def self.paternal_aunts(person)
    father = person.mother&.spouse

    return [] if father.nil?

    siblings(father).select { |sibling| sibling.gender == Gender::FEMALE }
  end

  def self.maternal_aunts(person)
    mother = person.mother

    return [] if mother.nil?

    siblings(mother).select { |sibling| sibling.gender == Gender::FEMALE }
  end

  def self.sisters_in_law(person)
    spouse_sisters = if person.spouse.nil?
                       []
                     else
                       siblings(person.spouse).select { |spouse_sibling| spouse_sibling&.gender == Gender::FEMALE }
                     end

    wive_of_siblings = siblings(person).map(&:spouse).select do |wife_of_sibling|
      wife_of_sibling&.gender == Gender::FEMALE
    end

    spouse_sisters + wive_of_siblings
  end

  def self.brothers_in_law(person)
    spouse_brothers = if person.spouse.nil?
                        []
                      else
                        siblings(person.spouse).select { |spouse_sibling| spouse_sibling&.gender == Gender::MALE }
                      end

    husband_of_siblings = siblings(person).map(&:spouse).select do |husband_of_sibling|
      husband_of_sibling&.gender == Gender::MALE
    end

    spouse_brothers + husband_of_siblings
  end
end
