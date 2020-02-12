require 'rails_helper'

RSpec.describe Lesson, type: :model do
  before :each do
    @file = file_fixture('content/year-8-history/roman-history/1-the-battle-of-hastings/_index.md')
    subject.from_file(@file)
  end

  describe "parts" do
    # There are multiple 1.x.md files in the test fixtures, we want to select
    # just one from each grouping
    it "returns a list of default activities" do
      actual = subject.parts
      expect(actual.first.filename.to_s).to end_with('1.md')
      expect(actual.second.filename.to_s).to end_with('2.md')
    end
  end

  describe "unit" do
    it "returns the parent Unit" do
      actual = subject.unit
      expect(actual).to be_a(Unit)
    end

    it "returns an parent instance where self is within children" do
      actual = subject.unit
      expect(actual.children.first).to be_a(described_class)
      expect(actual.children).to include(subject)
    end
  end

  describe "activities" do
    it "returns a array of activities" do
      actual = subject.activities
      expect(actual).to be_a(Array)
      expect(actual.first).to be_a(Activity)
    end
  end

  describe "parts_for_teacher" do
    it "returns a custom array of chosen parts"
    it "returns a default list of parts when none chosen"
  end
end
