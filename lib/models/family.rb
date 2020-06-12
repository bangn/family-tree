# frozen_string_literal: true

require "error"
require "gender"
require "models/person"

class Family
  attr_accessor :members

  def initialize(father_name:, mother_name:)
    father = Person.new(name: father_name, gender: Gender::MALE)
    mother = Person.new(name: mother_name, gender: Gender::FEMALE)

    father.add_spouse(mother)

    @members = [father, mother]
  end

  def add_child(mother_name:, child_name:, gender:)
    mother = find(name: mother_name)

    raise Error::PersonNotFound if mother.nil?

    raise Error::InappropriateMotherGender if mother.gender == Gender::MALE

    child = Person.new(name: child_name, gender: gender)
    @members.push(child)
    mother.add_child(child)
  end

  def marry(child_name:, spouse_name:, gender:)
    child = find(name: child_name)

    raise Error::PersonNotFound if child.nil?

    child_spouse = Person.new(name: spouse_name, gender: gender)
    child.add_spouse(child_spouse)

    @members.push(child_spouse)
  end

  def get_relationhip(name:, relationship_type:)
    person = find(name: name)

    raise Error::PersonNotFound if person.nil?

    if !Relationship.supported_relationships.include?(relationship_type.upcase)
      raise Error::NotSupportedRelationship
    end

    case relationship_type.upcase
    when Relationship::DAUGHTER
      return person.daughters
    when Relationship::SON
      return person.sons
    else
      return []
    end
  end

  def find(name:)
    @members.find { |person| person.name == name }
  end
end
