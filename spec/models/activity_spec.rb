require 'rails_helper'

RSpec.describe Activity, type: :model do
  before :each do
    @file = file_fixture('content/year-8-history/roman-history/1-the-battle-of-hastings/1.md')
    subject.from_file(@file)
  end

  describe "slug" do
    it "returns the basefile name without extension" do
      expect(subject.slug).to eql("1")
    end
  end

  describe "lesson" do
    it "returns the parent association" do
      expect(subject.lesson).to be_a(Lesson)
      expect(subject.lesson.slug).to eql('1-the-battle-of-hastings')
    end

    it "returns an parent instance where self is within children" do
      actual = subject.lesson
      expect(actual.children.first).to be_a(described_class)
      expect(actual.children).to include(subject)
    end
  end

  describe "part" do
    it "returns a float of the of the filename" do
      subject.instance_variable_set(:@filename, 'something/1.1.md')
      expect(subject.part).to eql(1.1)
    end

    it "returns a start float of a string filename" do
      subject.instance_variable_set(:@filename, 'something/1.2-something3.md')
      expect(subject.part).to eql(1.2)
    end
  end

  describe "path" do
    it "returns a generated path" do
      expect(subject.path).to eql('/teachers/ccps/year-8-history/roman-history/1-the-battle-of-hastings/1')
    end
  end
end
