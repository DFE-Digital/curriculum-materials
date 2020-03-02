require 'rails_helper'

describe Download, type: :model do
  let :lesson_bundle_path do
    File.join(Rails.application.root, 'spec', 'fixtures', 'lesson_bundle.zip')
  end

  context 'relationships' do
    it { is_expected.to belong_to :teacher }
    it { is_expected.to belong_to :lesson }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :teacher }
    it { is_expected.to validate_presence_of :lesson }

    it do
      is_expected.to \
        validate_content_type_of(:lesson_bundle).allowing 'application/zip'
    end
  end

  context '#lesson_bundle' do
    let :download do
      create :download
    end

    before do
      download.lesson_bundle.attach \
        io: File.open(lesson_bundle_path),
        filename: 'lesson_bundle.zip',
        content_type: 'application/zip'
    end

    subject { download.lesson_bundle }

    it { is_expected.to be_attached }

    it "is attached correctly" do
      expect(subject.filename).to eq 'lesson_bundle.zip'
      expect(subject.content_type).to eq 'application/zip'
      expect(subject.download).to eq File.binread(lesson_bundle_path)
    end
  end

  context 'states' do
    subject { create :download }

    context 'without a lesson_bundle' do
      it 'cannot transition to completed' do
        expect { subject.transition_to! :completed }.to \
          raise_error Statesman::GuardFailedError

        expect(subject).to be_in_state(:pending)
      end
    end

    context 'with a lesson_bundle' do
      before do
        subject.lesson_bundle.attach \
          io: File.open(lesson_bundle_path),
          filename: 'lesson_bundle.zip',
          content_type: 'application/zip'
      end

      it 'can transition to completed' do
        subject.transition_to! :completed
        expect(subject).to be_in_state(:completed)
      end
    end
  end
end
