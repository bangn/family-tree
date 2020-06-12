# frozen_string_literal: true

require "error"
require "models/family"
require "relationship"

describe Relationship do
  describe "#get" do
    let(:family) { king_shan_family }

    describe "when the person is not part of the family" do
      it "throws PersonNotFound error" do
        expect do
          Relationship.get(relationship_type: Relationship::SON, family: family, name: "does_not_exist")
        end.to raise_error(Error::PersonNotFound)
      end
    end

    describe "when the relationship is not supported" do
      it "throws NotSupportedRelationship error" do
        expect do
          Relationship.get(relationship_type: "NOT_SUPPORTED", family: family, name: "Chit")
        end.to raise_error(Error::NotSupportedRelationship)
      end
    end

    describe "when the relationship is daughters" do
      let(:shan_daughters) do
        Relationship.get(relationship_type: Relationship::DAUGHTER, family: family, name: "Shan")
      end

      it "returns correct number of dauthers of specified person" do
        expect(shan_daughters.count).to eq(1)
      end
    end

    describe "when the relationship is son" do
      let(:shan_sons) do
        Relationship.get(relationship_type: Relationship::SON, family: family, name: "Shan")
      end

      it "returns correct sons of specified person" do
        expect(shan_sons.count).to eq(4)
      end

      it "returns sons of specified person in correct order it was added" do
        expect(shan_sons.map(&:name)).to eq(["Chit", "Ish", "Vich", "Aras"])
      end
    end

    describe "when the relationship is siblings" do
      describe "when the person has siblings" do
        let(:chit_siblings) do
          Relationship.get(relationship_type: Relationship::SIBLINGS, family: family, name: "Chit")
        end

        it "returns correct siblings of specified person" do
          expect(chit_siblings.count).to eq(4)
        end

        it "returns siblings of specified person in correct order it was added" do
          expect(chit_siblings.map(&:name)).to eq(["Ish", "Vich", "Aras", "Satya"])
        end
      end

      describe "when the person does not have a siblings" do
        it "returns empty array" do
          expect(
            Relationship.get(relationship_type: Relationship::SIBLINGS, family: family, name: "Shan")
          ).to eq([])

          expect(
            Relationship.get(relationship_type: Relationship::SIBLINGS, family: family, name: "Anga")
          ).to eq([])

          expect(
            Relationship.get(relationship_type: Relationship::SIBLINGS, family: family, name: "Yodhan")
          ).to eq([])

          expect(
            Relationship.get(relationship_type: Relationship::SIBLINGS, family: family, name: "Jaya")
          ).to eq([])
        end
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
