# frozen_string_literal: true

require "error"
require "gender"

class Person
  attr_accessor :name, :gender, :spouses, :children, :mother

  def initialize(name:, gender:)
    if (gender != Gender::MALE) && (gender != Gender::FEMALE)
      raise Error::NotSupportedGender
    end

    @name = name
    @gender = gender
    @spouses = []
    @children = []
  end

  def add_spouse(spouse)
    spouses.push(spouse)
    spouse.spouses.push(self)
  end

  def add_child(child)
    children.push(child)
  end
end
