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
      expect(father.spouse).to eq(mother)
    end

    it "assigns mother as mother's spouse" do
      expect(mother.spouse).to eq(father)
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

        expect(child.spouse.name).to eq(child_spouse_name)
      end
    end
  end
end
