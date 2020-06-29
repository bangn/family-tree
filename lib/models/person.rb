# frozen_string_literal: true

require "error"
require "gender"

class Person
  attr_accessor :name, :gender, :spouse, :children, :mother

  def initialize(name:, gender:)
    raise Error::NotSupportedGender unless Gender.supported_genders.include?(gender.upcase)

    @name = name
    @gender = gender.upcase
    @children = []
  end

  def add_spouse(person)
    @spouse = person
    person.spouse = self
  end

  def add_child(child)
    @children.push(child)
    @spouse&.children&.push(child)
  end
end
