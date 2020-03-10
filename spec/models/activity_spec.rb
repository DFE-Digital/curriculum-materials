require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:lesson_part_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:overview).of_type(:text) }
    it { is_expected.to have_db_column(:duration).of_type(:integer) }
    it { is_expected.to have_db_column(:extra_requirements).of_type(:string).with_options(array: true) }
    it { is_expected.to have_db_column(:default).of_type(:boolean).with_options(null: false) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:lesson_part) }
    it { is_expected.to have_many(:activity_teaching_methods).dependent(:destroy) }
    it { is_expected.to have_many(:activity_choices).dependent(:destroy) }
    it { is_expected.to have_many(:teaching_methods).through(:activity_teaching_methods) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:lesson_part_id) }

    describe '#name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(128) }
    end

    it { is_expected.to validate_presence_of(:overview) }

    describe '#duration' do
      it { is_expected.to validate_presence_of(:duration) }
      it { is_expected.to validate_numericality_of(:duration).is_less_than_or_equal_to(60) }
    end

    describe '#default' do
      context 'when default' do
        subject { create :activity, default: true }

        it do
          is_expected.to \
            validate_uniqueness_of(:default).scoped_to(:lesson_part_id)
        end
      end

      context 'when not default' do
        subject { create :activity, default: false }

        it do
          is_expected.not_to \
            validate_uniqueness_of(:default).scoped_to(:lesson_part_id)
        end
      end
    end

    context 'attachments' do
      it do
        is_expected.to \
          validate_size_of(:teacher_resources).less_than(50.megabytes)
      end

      it do
        is_expected.to \
          validate_size_of(:pupil_resources).less_than(50.megabytes)
      end

      # This test seems to hang for some reason :-/
      xit do
        is_expected.to \
          validate_content_type_of(:pupil_resources)
            .allowing(Activity::ALLOWED_CONTENT_TYPES)
      end

      # This test seems to hang for some reason :-/
      xit do
        is_expected.to \
          validate_content_type_of(:teacher_resources)
            .allowing(Activity::ALLOWED_CONTENT_TYPES)
      end

      it do
        is_expected.to \
          validate_content_type_of(:slide_deck)
            .allowing(Activity::SLIDE_DECK_CONTENT_TYPE)
      end
    end
  end

  context 'attachments' do
    let :attachment_path do
      File.join(Rails.application.root, 'spec', 'fixtures', '1px.png')
    end

    let :slide_deck_path do
      File.join(Rails.application.root, 'spec', 'fixtures', 'slide_1_keyword_match_up.odp')
    end

    let(:activity) { create :activity }

    context '#pupil_resources' do
      before do
        activity.pupil_resources.attach \
          io: File.open(attachment_path),
          filename: 'pupil-test-image.png',
          content_type: 'image/png'
      end

      subject { activity.pupil_resources.last }

      it { is_expected.to be_persisted }

      it "is attached correctly" do
        expect(subject.filename).to eq 'pupil-test-image.png'
        expect(subject.content_type).to eq 'image/png'
        expect(subject.download).to eq File.binread(attachment_path)
      end
    end

    context '#teacher_resources' do
      before do
        activity.teacher_resources.attach \
          io: File.open(attachment_path),
          filename: 'teacher-test-image.png',
          content_type: 'image/png'
      end

      subject { activity.teacher_resources.last }

      it { is_expected.to be_persisted }

      it "is attached correctly" do
        expect(subject.filename).to eq 'teacher-test-image.png'
        expect(subject.content_type).to eq 'image/png'
        expect(subject.download).to eq File.binread(attachment_path)
      end
    end

    context '#slide_deck' do
      before do
        activity.slide_deck.attach \
          io: File.open(slide_deck_path),
          filename: 'slide-deck.odp',
          content_type: 'application/vnd.oasis.opendocument.presentation'
      end

      subject { activity.slide_deck }

      it "is attached correctly" do
        expect(subject.filename).to eq 'slide-deck.odp'
        expect(subject.content_type).to eq 'application/vnd.oasis.opendocument.presentation'
        expect(subject.download).to eq File.binread(slide_deck_path)
      end
    end
  end

  describe 'scopes' do
    describe '.omit' do
      let(:activities) { create_list(:activity, 2) }
      let(:unwanted_activity) { create(:activity) }

      specify 'the unwanted activity should be omitted' do
        expect(Activity.omit(unwanted_activity)).not_to include(unwanted_activity)
      end

      specify 'the other activities should be present' do
        expect(Activity.omit(unwanted_activity)).to match_array(activities)
      end
    end
  end

  describe 'methods' do
    describe '#alternatives' do
      it { is_expected.to respond_to(:alternatives) }

      let(:current_activity) { create(:activity) }
      let(:other_activities) { create(:activity, lesson_part: current_activity.lesson_part) }

      specify 'returns siblings but not self' do
        expect(current_activity.alternatives).to match_array(other_activities)
      end
    end
  end
end
