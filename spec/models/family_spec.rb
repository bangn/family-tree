# frozen_string_literal: true

require "faker"

require "error"
require "models/family"
require "relationship"

RSpec.describe Family do
  let(:father_name) { Faker::Name.first_name }
  let(:mother_name) { Faker::Name.first_name }
  let(:child_name) { Faker::Name.first_name }
  let(:family) { Family.new(father_name: father_name, mother_name: mother_name) }

  describe ".initialize" do
    let(:father) { family.members.first }
    let(:mother) { family.members.last }

    it "initialises family with 2 members" do
      expect(family.members.count).to eq(2)
    end

    it "assigns father as mother's spouse" do
      expect(father.spouses.count).to eq(1)
      expect(father.spouses.first).to eq(mother)
    end

    it "assigns mother as mother's spouse" do
      expect(mother.spouses.count).to eq(1)
      expect(mother.spouses.first).to eq(father)
    end
  end

  describe ".add_child" do
    context "when mother name does not exist" do
      it "throws PersonNotFound error" do
        expect do
          family.add_child(mother_name: "does_not_exist", child_name: child_name, gender: Gender::MALE)
        end.to raise_error(Error::PersonNotFound)
      end
    end

    context "when adding child via father name" do
      it "throws ChildAdditionFailed error" do
        expect do
          family.add_child(mother_name: father_name, child_name: child_name, gender: Gender::FEMALE)
        end.to raise_error(Error::InappropriateMotherGender)
      end
    end

    context "when adding child via mother name" do
      before(:each) do
        family.add_child(mother_name: mother_name, child_name: child_name, gender: Gender::FEMALE)
      end

      it "appends a child to family members" do
        expect(family.members.count).to eq(3)
        expect(family.members.last.name).to eq(child_name)
      end

      it "appends child to mother's children" do
        mother = family.members[1]

        expect(mother.children.count).to eq(1)
        expect(mother.children.first.name).to eq(child_name)
      end

      it "assigns a mother to the child" do
        child = family.find(name: child_name)
        expect(child.mother.name).to eq(mother_name)
      end
    end
  end

  describe ".marry" do
    let(:child_spouse_name) { Faker::Name.first_name }

    describe "when person is not a member of the family" do
      it "throws PersonNotFound error" do
        expect do
          family.marry(child_name: child_name, spouse_name: child_spouse_name, gender: Gender::FEMALE)
        end.to raise_error(Error::PersonNotFound)
      end
    end

    describe "when person is a member of the family" do
      before(:each) do
        family.add_child(mother_name: mother_name, child_name: child_name, gender: Gender::MALE)
        family.marry(child_name: child_name, spouse_name: child_spouse_name, gender: Gender::FEMALE)
      end

      it "appends new member to the family" do
        expect(family.members.count).to eq(4)
      end

      it "assigns spouse to the child" do
        child = family.find(name: child_name)

        expect(child.spouses.first.name).to eq(child_spouse_name)
      end
    end
  end

  describe ".get_relationhip" do
    let(:family) { king_shan_family }

    describe "when the person is not part of the family" do
      it "throws PersonNotFound error" do
        expect do
          family.get_relationhip(name: "does_not_exist", relationship_type: Relationship::SON)
        end.to raise_error(Error::PersonNotFound)
      end
    end

    describe "when the relationship is not supported" do
      it "throws NotSupportedRelationship error" do
        expect do
          family.get_relationhip(name: "Chit", relationship_type: "NOT_SUPPORTED")
        end.to raise_error(Error::NotSupportedRelationship)
      end
    end

    describe "when the relationship is dauther" do
      let(:shan_daughters) do
        family.get_relationhip(name: "Shan", relationship_type: Relationship::DAUGHTER)
      end

      it "returns correct number of dauthers of specified person" do
        expect(shan_daughters.count).to eq(1)
      end
    end

    describe "when the relationship is son" do
      let(:shan_sons) do
        family.get_relationhip(name: "Shan", relationship_type: Relationship::SON)
      end

      it "returns correct sons of specified person" do
        expect(shan_sons.count).to eq(4)
      end

      it "returns sons of specified person in correct order it was added" do
        expect(shan_sons.map(&:name)).to eq(["Chit", "Ish", "Vich", "Aras"])
      end
    end

    describe "when the relationship is siblings" do
      let(:shan_siblings) do
        family.get_relationhip(name: "Chit", relationship_type: Relationship::SIBLINGS)
      end

      it "returns correct siblings of specified person" do
        expect(shan_siblings.count).to eq(4)
      end

      it "returns siblings of specified person in correct order it was added" do
        expect(shan_siblings.map(&:name)).to eq(["Ish", "Vich", "Aras", "Satya"])
      end
    end
  end
end

def king_shan_family
  # First generation
  family = Family.new(father_name: "Shan", mother_name: "Anga")

  # Second generation
  family.add_child(mother_name: "Anga", child_name: "Chit", gender: Gender::MALE)
  family.add_child(mother_name: "Anga", child_name: "Ish", gender: Gender::MALE)
  family.add_child(mother_name: "Anga", child_name: "Vich", gender: Gender::MALE)
  family.add_child(mother_name: "Anga", child_name: "Aras", gender: Gender::MALE)
  family.add_child(mother_name: "Anga", child_name: "Satya", gender: Gender::FEMALE)

  # Second generation with spouse
  family.marry(child_name: "Chit", spouse_name: "Amba", gender: Gender::FEMALE)
  family.marry(child_name: "Vich", spouse_name: "Lika", gender: Gender::FEMALE)
  family.marry(child_name: "Aras", spouse_name: "Chitra", gender: Gender::FEMALE)
  family.marry(child_name: "Satya", spouse_name: "Vyan", gender: Gender::MALE)

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
  family.marry(child_name: "Dritha", spouse_name: "Jaya", gender: Gender::MALE)
  family.marry(child_name: "Jnki", spouse_name: "Arit", gender: Gender::MALE)
  family.marry(child_name: "Asva", spouse_name: "Satvy", gender: Gender::FEMALE)
  family.marry(child_name: "Vyas", spouse_name: "Krpi", gender: Gender::FEMALE)

  # Fourth generation
  family.add_child(mother_name: "Dritha", child_name: "Yodhan", gender: Gender::MALE)
  family.add_child(mother_name: "Jnki", child_name: "Laki", gender: Gender::MALE)
  family.add_child(mother_name: "Jnki", child_name: "Lavnya", gender: Gender::FEMALE)
  family.add_child(mother_name: "Satvy", child_name: "Vasa", gender: Gender::MALE)
  family.add_child(mother_name: "Krpi", child_name: "Kriya", gender: Gender::MALE)
  family.add_child(mother_name: "Krpi", child_name: "Krithi", gender: Gender::FEMALE)

  family
end
