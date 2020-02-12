require 'rails_helper'

RSpec.describe Unit, type: :model do
  before :each do
    @file = file_fixture('content/year-8-history/roman-history/_index.md')
    subject.from_file(@file)
  end

  describe "ccp" do
    it "returns he parent object instance" do
      actual = subject.parent
      expect(actual).to be_a(CompleteCurriculumProgramme)
    end

    it "returns an parent instance where self is within children" do
      actual = subject.parent
      expect(actual.children).to include(subject)
    end
  end

  describe "lessons" do
    it "returns an array of Lesson instances" do
      actual = subject.lessons
      expect(actual).to be_a(Array)
      expect(actual.first).to be_a(Lesson)
    end
  end
end
