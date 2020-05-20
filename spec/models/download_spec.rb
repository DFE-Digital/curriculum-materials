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

  context 'scopes' do
    let!(:recently_pending)       { create :download }
    let!(:historically_pending)   { create :download, :historic }
    let!(:recently_completed)     { create :download, :completed }
    let!(:historically_completed) { create :download, :completed, :historic }
    let!(:recently_failed)        { create :download, :failed }
    let!(:historically_failed)    { create :download, :failed, :historic }
    let!(:recently_purged)        { create :download, :cleaned_up }
    let!(:historically_purged)    { create :download, :cleaned_up, :historic }

    context '.historic' do
      subject { described_class.historic }

      it {
        is_expected.to match_array [
          historically_pending,
          historically_completed,
          historically_failed,
          historically_purged
        ]
      }
    end

    context '.completed' do
      subject { described_class.completed }

      it {
        is_expected.to match_array [historically_completed, recently_completed]
      }
    end

    context '.to_clean_up' do
      subject { described_class.to_clean_up }

      it { is_expected.to match_array [historically_completed] }
    end
  end

  describe 'methods' do
    describe '#lesson_parts' do
      subject { create(:download) }
      let(:teacher) { subject.teacher }

      before do
        allow(subject.lesson).to(
          receive(:lesson_parts_for)
            .with(teacher)
            .and_return([])
        )
      end

      before { subject.lesson_parts }

      it "should use Lesson#lesson_parts_for with assigned lesson and teacher" do
        expect(subject.lesson).to have_received(:lesson_parts_for).with(teacher)
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
  end

  context 'states' do
    context 'transitions' do
      context 'pending to completed' do
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

      context 'completed to cleaned_up' do
        subject { create :download, :completed }

        context 'when the lesson_bundle is still attached' do
          it 'cannot transistion to cleaned_up' do
            expect { subject.transition_to! :cleaned_up }.to \
              raise_error Statesman::GuardFailedError

            expect(subject).to be_in_state :completed
          end
        end

        context 'when the lesson_bundle is not attached' do
          before do
            subject.lesson_bundle.purge
          end

          it 'can transistion to cleaned_up' do
            subject.transition_to! :cleaned_up
            expect(subject).to be_in_state :cleaned_up
          end
        end
      end
    end
  end
end
