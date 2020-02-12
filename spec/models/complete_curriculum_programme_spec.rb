require 'rails_helper'

RSpec.describe CompleteCurriculumProgramme, type: :model do
  before :each do
    @file = file_fixture('content/year-8-history/_index.md')
    subject.from_file(@file)
  end

  describe "self" do
    describe "all" do
      it "returns an array of all CCP models" do
        actual = described_class.all
        expect(actual).to be_a(Array)
        expect(actual.first).to be_a(CompleteCurriculumProgramme)
      end
    end

    describe "first" do
    end
  end

  describe "path" do
    it "returns a generated path" do
      expect(subject.path).to eql('/teachers/ccps/year-8-history')
    end
  end

  describe "units" do
    it "returns an array of child Unit models" do
      actual = subject.units
      expect(actual).to be_a(Array)
      expect(actual.first).to be_a(Unit)
    end
  end
end
