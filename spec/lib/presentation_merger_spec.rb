require "zip"
require "spec_helper"
require_relative "../../app/lib/presentation_merger"

RSpec.shared_examples "a ODP zip" do
  it "Zip contains required ODP files" do
    files = []
    Zip::File.open_buffer(subject) do |zipfile|
      files = zipfile.entries.map(&:name)
    end
    expect(files).to include("content.xml")
    expect(files).to include("styles.xml")
    expect(files).to include("META-INF/manifest.xml")
  end
end

describe PresentationMerger do
  let(:file1) { File.new(File.join(File.dirname(__FILE__), "..", "fixtures", "file1.odp")) }

  describe ".write_buffer" do
    subject do
      described_class.write_buffer do |pres|
        pres << file1
      end
    end

    it "is a StringIO" do
      expect(subject).to be_a(StringIO)
    end

    it_behaves_like "a ODP zip"
  end

  describe ".open" do
    let(:out_file) { Tempfile.new("out.odp") }
    subject do
      described_class.open(out_file) do |pres|
        pres << file1
      end
      out_file
    end

    it "populates the file" do
      subject
      expect(out_file.size).to be > 0
    end

    it_behaves_like "a ODP zip"
  end

  describe "#<<" do
    subject { described_class.new(StringIO.new(""), true) }
    it "appends the given file to the end of the files array" do
      subject << file1
      expect(subject.files).to include(file1)
    end
  end

  describe "#close" do
    subject do
      instance = described_class.new(Tempfile.new("merge.odp"))
      instance << file1
      instance.close
    end

    it_behaves_like "a ODP zip"
  end

  describe "#close_buffer" do
    subject do
      instance = described_class.new(StringIO.new(""), true)
      instance << file1
      instance.close_buffer
    end

    it "is a StringIO" do
      expect(subject).to be_a(StringIO)
    end

    it_behaves_like "a ODP zip"
  end

  describe "#run_command" do
    it "raises ProcessExitError when unsuccessful" do
      instance = described_class.new(StringIO.new(""), true)
      file = double
      allow(file).to receive(:path).and_return('./l33.t')
      allow(instance).to receive(:files).and_return([file])
      expect {
        instance.close_buffer
      }.to raise_error(StandardError, /One or more files provided is non existant./)
    end
  end
end
