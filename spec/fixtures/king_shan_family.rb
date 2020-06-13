# frozen_string_literal: true

require "models/family"

class KingShanFamily
  def self.create
    # First generation
    family = Family.new(father_name: "Shan", mother_name: "Anga")

    # Second generation
    family.add_child(mother_name: "Anga", child_name: "Chit", gender: Gender::MALE)
    family.add_child(mother_name: "Anga", child_name: "Ish", gender: Gender::MALE)
    family.add_child(mother_name: "Anga", child_name: "Vich", gender: Gender::MALE)
    family.add_child(mother_name: "Anga", child_name: "Aras", gender: Gender::MALE)
    family.add_child(mother_name: "Anga", child_name: "Satya", gender: Gender::FEMALE)

    # Second generation with spouse
    family.marry(name: "Chit", spouse_name: "Amba", gender: Gender::FEMALE)
    family.marry(name: "Vich", spouse_name: "Lika", gender: Gender::FEMALE)
    family.marry(name: "Aras", spouse_name: "Chitra", gender: Gender::FEMALE)
    family.marry(name: "Satya", spouse_name: "Vyan", gender: Gender::MALE)

    # Third generation
    family.add_child(mother_name: "Amba", child_name: "Dritha", gender: Gender::FEMALE)
    family.add_child(mother_name: "Amba", child_name: "Tritha", gender: Gender::FEMALE)
    family.add_child(mother_name: "Amba", child_name: "Vritha", gender: Gender::MALE)

    family.add_child(mother_name: "Lika", child_name: "Vila", gender: Gender::FEMALE)
    family.add_child(mother_name: "Lika", child_name: "Chika", gender: Gender::FEMALE)

    family.add_child(mother_name: "Chitra", child_name: "Jnki", gender: Gender::FEMALE)
    family.add_child(mother_name: "Chitra", child_name: "Ahit", gender: Gender::MALE)

    family.add_child(mother_name: "Satya", child_name: "Asva", gender: Gender::MALE)
    family.add_child(mother_name: "Satya", child_name: "Vyas", gender: Gender::MALE)
    family.add_child(mother_name: "Satya", child_name: "Atya", gender: Gender::FEMALE)

    # Third generation with spouse
    family.marry(name: "Dritha", spouse_name: "Jaya", gender: Gender::MALE)
    family.marry(name: "Jnki", spouse_name: "Arit", gender: Gender::MALE)
    family.marry(name: "Asva", spouse_name: "Satvy", gender: Gender::FEMALE)
    family.marry(name: "Vyas", spouse_name: "Krpi", gender: Gender::FEMALE)

    # Fourth generation
    family.add_child(mother_name: "Dritha", child_name: "Yodhan", gender: Gender::MALE)
    family.add_child(mother_name: "Jnki", child_name: "Laki", gender: Gender::MALE)
    family.add_child(mother_name: "Jnki", child_name: "Lavnya", gender: Gender::FEMALE)
    family.add_child(mother_name: "Satvy", child_name: "Vasa", gender: Gender::MALE)
    family.add_child(mother_name: "Krpi", child_name: "Kriya", gender: Gender::MALE)
    family.add_child(mother_name: "Krpi", child_name: "Krithi", gender: Gender::FEMALE)

    family
  end
end
