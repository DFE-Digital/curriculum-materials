require 'rails_helper'

class DummyContent < ContentBase
  has_many :units
  def self.all_files
    Dir.glob("content/*/_index.md")
  end
end

RSpec.describe DummyContent, type: :model do
  before :each do
    @file = file_fixture('content/year-8-history/roman-history/1-the-battle-of-hastings/_index.md')
    subject.from_file(@file)
  end

  describe ".all" do
    it "returns an array of all CCP models" do
      actual = described_class.all
      expect(actual).to be_a(Array)
      expect(actual.first).to be_a(ContentBase)
    end
  end

  describe ".has_many" do
    it "defines a constant CHILD_CLASS" do
      expect(described_class::CHILD_CLASS).to eql(Unit)
    end
  end

  describe "from_file" do
    it "reads from frontmatter formatted file" do
      subject.from_file(@file)
      expect(subject.slug).to eql("1-the-battle-of-hastings")
      expect(subject.title).to eql("The Battle of Hastings")
      expect(subject.content).to start_with('### How the lesson structure benefits pupils\' learning')
    end

    it "fails silently" do
      subject.from_file("")
    end
  end

  describe "from_file!" do
    it "reads from frontmatter formatted file" do
      subject.from_file!(@file)
      expect(subject.slug).to eql("1-the-battle-of-hastings")
      expect(subject.title).to eql("The Battle of Hastings")
      expect(subject.content).to start_with('### How the lesson structure benefits pupils\' learning')
    end

    it "fails silently" do
      expect {
        subject.from_file!("")
      }.to raise_error(described_class::RecordNotFound)
    end
  end
end
