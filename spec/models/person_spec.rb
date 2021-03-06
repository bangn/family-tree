# frozen_string_literal: true

require "faker"

require "error"
require "gender"
require "models/person"

RSpec.describe Person do
  let(:person_name) { Faker::Name.first_name }

  describe ".initialize" do
    context "when gender is MALE" do
      it "creates a person" do
        person = Person.new(name: person_name, gender: Gender::MALE)

        expect(person.name).to eq(person_name)
        expect(person.gender).to eq(Gender::MALE)
      end
    end

    context "when gender is FEMALE" do
      it "creates a person" do
        person = Person.new(name: person_name, gender: Gender::FEMALE)

        expect(person.name).to eq(person_name)
        expect(person.gender).to eq(Gender::FEMALE)
      end
    end

    context "when gender is neither MALE or FEMALE" do
      it "throws error" do
        expect do
          Person.new(name: person_name, gender: "unknown")
        end.to raise_error(Error::NotSupportedGender)
      end
    end
  end

  describe ".add_spouse" do
    let(:husband) { Person.new(name: Faker::Name.first_name, gender: Gender::MALE) }
    let(:wife) { Person.new(name: Faker::Name.first_name, gender: Gender::FEMALE) }

    it "assigns the spouse to a person" do
      husband.add_spouse(wife)

      expect(husband.spouse).to eq(wife)
    end

    it "assigns a person to the spouse" do
      husband.add_spouse(wife)

      expect(wife.spouse).to eq(husband)
    end
  end

  describe ".add_child" do
    let(:person) { Person.new(name: Faker::Name.first_name, gender: Gender::FEMALE) }
    let(:child) { Person.new(name: Faker::Name.first_name, gender: Gender::FEMALE) }

    describe "when the person does not have spouse" do
      it "adds child to the person" do
        person.add_child(child)
        expect(person.children.count).to eq(1)
      end
    end

    describe "when the person has spouse" do
      let(:person_spouse) { Person.new(name: Faker::Name.first_name, gender: Gender::MALE) }

      before(:each) { person.add_spouse(person_spouse) }

      it "adds child to the person" do
        person.add_child(child)
        expect(person.children.count).to eq(1)
      end

      it "adds child to the person's spouse" do
        person.add_child(child)
        expect(person.spouse.children.count).to eq(1)
      end
    end
  end
end
