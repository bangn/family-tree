# frozen_string_literal: true

require "error"
require "models/family"
require "relationship"

require_relative "./fixtures/king_shan_family"

RSpec.describe Relationship do
  describe "#get" do
    let(:family) { KingShanFamily.create }

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

      context "when the person is not part of the family" do
        it "throws PersonNotFound error" do
          expect do
            Relationship.get(relationship_type: Relationship::SON, family: family, name: "does_not_exist")
          end.to raise_error(Error::PersonNotFound)
        end
      end
    end

    describe "dauthers" do
      let(:shan_daughters) do
        Relationship.get(relationship_type: Relationship::DAUGHTER, family: family, name: "Shan")
      end

      it "returns correct number of dauthers of specified person" do
        expect(shan_daughters.count).to eq(1)
      end
    end

    describe "sons" do
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

    describe "siblings" do
      context "when the person has siblings" do
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

      context "when the person does not have a siblings" do
        it "returns empty array" do
          expect(
            Relationship.get(relationship_type: Relationship::SIBLINGS, family: family, name: "Shan"),
          ).to eq([])

          expect(
            Relationship.get(relationship_type: Relationship::SIBLINGS, family: family, name: "Anga"),
          ).to eq([])

          expect(
            Relationship.get(relationship_type: Relationship::SIBLINGS, family: family, name: "Yodhan"),
          ).to eq([])

          expect(
            Relationship.get(relationship_type: Relationship::SIBLINGS, family: family, name: "Jaya"),
          ).to eq([])
        end
      end
    end

    describe "paternal uncles" do
      context "when the person has paternal uncles" do
        let(:dritha_paternal_uncles) do
          Relationship.get(relationship_type: Relationship::PATERNAL_UNCLE, family: family, name: "Dritha")
        end

        it "returns correct number of persons" do
          expect(dritha_paternal_uncles.count).to eq(3)
        end

        it "returns correct order as a person was added" do
          expect(dritha_paternal_uncles.map(&:name)).to eq(["Ish", "Vich", "Aras"])
        end
      end

      context "when the person does not have paternal uncles" do
        it "returns empty array" do
          expect(
            Relationship.get(relationship_type: Relationship::PATERNAL_UNCLE, family: family, name: "Laki"),
          ).to eq([])
        end
      end

      context "when the person does not have father" do
        it "returns empty array" do
          expect(
            Relationship.get(relationship_type: Relationship::PATERNAL_UNCLE, family: family, name: "Shan"),
          ).to eq([])
        end
      end
    end

    describe "maternal uncles" do
      context "when the person has maternal uncles" do
        let(:asva_maternal_uncles) do
          Relationship.get(relationship_type: Relationship::MATERNAL_UNCLE, family: family, name: "Asva")
        end

        it "returns correct number of persons" do
          expect(asva_maternal_uncles.count).to eq(4)
        end

        it "returns correct order as a person was added" do
          expect(asva_maternal_uncles.map(&:name)).to eq(["Chit", "Ish", "Vich", "Aras"])
        end
      end

      context "when the person does not have maternal uncles" do
        it "returns empty array" do
          expect(
            Relationship.get(relationship_type: Relationship::MATERNAL_UNCLE, family: family, name: "Vasa"),
          ).to eq([])
        end
      end

      context "when the person does not have mother" do
        it "returns empty array" do
          expect(
            Relationship.get(relationship_type: Relationship::MATERNAL_UNCLE, family: family, name: "Shan"),
          ).to eq([])
        end
      end
    end

    describe "paternal aunts" do
      context "when the person has paternal aunts" do
        let(:dritha_paternal_aunts) do
          Relationship.get(relationship_type: Relationship::PATERNAL_AUNT, family: family, name: "Dritha")
        end

        it "returns correct number of persons" do
          expect(dritha_paternal_aunts.count).to eq(1)
        end
      end

      context "when the person does not have paternal aunts" do
        it "returns empty array" do
          expect(
            Relationship.get(relationship_type: Relationship::PATERNAL_AUNT, family: family, name: "Laki"),
          ).to eq([])
        end
      end

      context "when the person does not have father" do
        it "returns empty array" do
          expect(
            Relationship.get(relationship_type: Relationship::PATERNAL_AUNT, family: family, name: "Shan"),
          ).to eq([])
        end
      end
    end

    describe "maternal aunts" do
      context "when the person has maternal aunts" do
        let(:yodhan_maternal_aunts) do
          Relationship.get(relationship_type: Relationship::MATERNAL_AUNT, family: family, name: "Yodhan")
        end

        it "returns correct number of persons" do
          expect(yodhan_maternal_aunts.count).to eq(1)
        end
      end

      context "when the person does not have maternal aunts" do
        it "returns empty array" do
          expect(
            Relationship.get(relationship_type: Relationship::MATERNAL_AUNT, family: family, name: "Laki"),
          ).to eq([])
        end
      end

      context "when the person does not have mother" do
        it "returns empty array" do
          expect(
            Relationship.get(relationship_type: Relationship::MATERNAL_AUNT, family: family, name: "Anga"),
          ).to eq([])
        end
      end
    end

    describe "sister in law" do
      context "when the person has spouse" do
        let (:chit_sisters_in_laws) do
          Relationship.get(relationship_type: Relationship::SISTER_IN_LAW, family: family, name: "Chit")
        end

        it "returns correct number of persons" do
          expect(chit_sisters_in_laws.count).to eq(2)
          expect(
            Relationship.get(relationship_type: Relationship::SISTER_IN_LAW, family: family, name: "Satvy").count,
          ).to eq(1)
          expect(
            Relationship.get(relationship_type: Relationship::SISTER_IN_LAW, family: family, name: "Jaya").count,
          ).to eq(1)
          expect(
            Relationship.get(relationship_type: Relationship::SISTER_IN_LAW, family: family, name: "Yodhan").count,
          ).to eq(0)
        end

        it "returns correct order as a person was added" do
          expect(chit_sisters_in_laws.map(&:name)).to eq(["Lika", "Chitra"])
        end
      end

      context "when the person does not have a spouse" do
        let (:ish_sisters_in_laws) do
          Relationship.get(relationship_type: Relationship::SISTER_IN_LAW, family: family, name: "Ish")
        end

        it "returns correct number of persons" do
          expect(ish_sisters_in_laws.count).to eq(3)

          expect(
            Relationship.get(relationship_type: Relationship::SISTER_IN_LAW, family: family, name: "Yodhan").count,
          ).to eq(0)
        end

        it "returns correct order as a person was added" do
          expect(ish_sisters_in_laws.map(&:name)).to eq(["Amba", "Lika", "Chitra"])
        end
      end
    end

    describe "brother in law" do
      context "when the person has spouse" do
        let (:chit_brothers_in_laws) do
          Relationship.get(relationship_type: Relationship::BROTHER_IN_LAW, family: family, name: "Chit")
        end

        it "returns correct number of persons" do
          expect(chit_brothers_in_laws.count).to eq(1)
          expect(
            Relationship.get(relationship_type: Relationship::BROTHER_IN_LAW, family: family, name: "Satvy").count,
          ).to eq(1)
          expect(
            Relationship.get(relationship_type: Relationship::BROTHER_IN_LAW, family: family, name: "Jaya").count,
          ).to eq(1)
          expect(
            Relationship.get(relationship_type: Relationship::BROTHER_IN_LAW, family: family, name: "Yodhan").count,
          ).to eq(0)
        end
      end

      context "when the person does not have a spouse" do
        it "returns correct number of persons" do
          expect(
            Relationship.get(relationship_type: Relationship::BROTHER_IN_LAW, family: family, name: "Ish").count,
          ).to eq(1)

          expect(
            Relationship.get(relationship_type: Relationship::BROTHER_IN_LAW, family: family, name: "Yodhan").count,
          ).to eq(0)
        end
      end
    end
  end
end
