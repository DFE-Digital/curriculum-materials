require 'rails_helper'

RSpec.describe Activity, type: :model do
  before :each do
    @file = file_fixture('content/year-8-history/roman-history/1-the-battle-of-hastings/1.md')
    subject.from_file(@file)
  end

  describe "from_file" do
    it "reads from frontmatter formatted file" do
      subject.from_file(@file)
      expect(subject.slug).to eql("1")
      expect(subject.title).to eql("Keyword matching")
      expect(subject.duration).to eql(300)
      expect(subject.taxonomies).to include("do-it-now")
      expect(subject.weight).to eql(1)
      expect(subject.content).to start_with('As students enter the room')
    end

    it "fails silently" do
      subject.from_file("")
    end
  end

  describe "from_file!" do
    it "reads from frontmatter formatted file" do
      subject.from_file!(@file)
      expect(subject.slug).to eql("1")
      expect(subject.title).to eql("Keyword matching")
      expect(subject.duration).to eql(300)
      expect(subject.taxonomies).to include("do-it-now")
      expect(subject.weight).to eql(1)
      expect(subject.content).to start_with('As students enter the room')
    end

    it "fails silently" do
      expect {
        subject.from_file!("")
      }.to raise_error(described_class::RecordNotFound)
    end
  end

  describe "path" do
    it "returns a generated path" do
      expect(subject.path).to eql('/teachers/ccps/year-8-history/roman-history/1-the-battle-of-hastings/1')
    end
  end

  describe "lesson" do
    it "returns the parent association" do
      expect(subject.lesson).to be_a(Lesson)
      expect(subject.lesson.slug).to eql('1-the-battle-of-hastings')
    end
  end
end
