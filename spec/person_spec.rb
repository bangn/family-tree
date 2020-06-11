# frozen_string_literal: true

require "error"
require "gender"
require "model/person"

RSpec.describe Person do
  describe ".initialize" do
    context "when gender is MALE" do
      it "creates a person" do
        person = Person.new(name: "Male", gender: Gender::MALE)

        expect(person.name).to eq("Male")
        expect(person.gender).to eq(Gender::MALE)
      end
    end

    context "when gender is FEMALE" do
      it "creates a person" do
        person = Person.new(name: "Female", gender: Gender::FEMALE)

        expect(person.name).to eq("Female")
        expect(person.gender).to eq(Gender::FEMALE)
      end
    end

    context "when gender is neither MALE or FEMALE" do
      it "throws error" do
        expect do
          Person.new(name: "Unknown Gender", gender: "unknown")
        end.to raise_error(Error::NotSupportedGender)
      end
    end
  end

  describe ".add_spouse" do
    let(:husband) { Person.new(name: "Husband", gender: Gender::MALE) }
    let(:wife) { Person.new(name: "Wife", gender: Gender::FEMALE) }

    it "appends the spouse to a person" do
      husband.add_spouse(wife)

      expect(husband.spouses.count).to eq(1)
      expect(husband.spouses.first).to eq(wife)
    end

    it "add the person to spouse" do
      husband.add_spouse(wife)

      expect(wife.spouses.count).to eq(1)
      expect(wife.spouses.first).to eq(husband)
    end
  end

  describe ".add_child" do
    let(:person) { Person.new(name: "Person", gender: Gender::FEMALE) }
    let(:child) { Person.new(name: "Child", gender: Gender::FEMALE) }

    it "adds child to the person" do
      person.add_child(child)
      expect(person.children.count).to eq(1)
    end
  end
end
