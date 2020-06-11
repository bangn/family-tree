# frozen_string_literal: true

require "error"
require "gender"
require "model/person"

class Family
  attr_accessor :members

  def initialize(father_name:, mother_name:)
    father = Person.new(name: father_name, gender: Gender::MALE)
    mother = Person.new(name: mother_name, gender: Gender::FEMALE)

    father.add_spouse(mother)
    mother.add_spouse(father)

    @members = [father, mother]
  end

  def add_child(mother_name:, child_name:, gender:)
    mother = @members.find { |person| person.name == mother_name }

    raise Error::PersonNotFound if mother.nil?

    raise Error::InappropriateMotherGender if mother.gender == Gender::MALE

    child = Person.new(name: child_name, gender: gender)
    @members.push(child)
    mother.add_child(child)
  end
end
