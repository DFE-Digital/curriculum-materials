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
end
