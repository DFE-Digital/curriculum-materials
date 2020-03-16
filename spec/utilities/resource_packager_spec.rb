require 'rails_helper'

RSpec.describe(ResourcePackager) do
  let(:download) { create(:download) }

  subject { ResourcePackager.new(download) }

  it { is_expected.to respond_to(:download) }
  it { is_expected.to respond_to(:lesson_bundle) }

  describe '#lesson_bundle' do
    let(:activity) { create(:activity) }
    let(:teacher_attachments) do
      [{ filename: '1px.png', content_type: 'image/png' }]
    end

    let(:pupil_attachments) do
      [{ filename: '1px.png', content_type: 'image/png' }]
    end

    let(:slide_deck_attachments) do
      [
        { filename: 'file1.odp', content_type: 'application/vnd.oasis.opendocument.presentation' },
        { filename: 'file2.odp', content_type: 'application/vnd.oasis.opendocument.presentation' }
      ]
    end

    before do
      teacher_attachments.each do |attachment|
        activity.teacher_resources.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', attachment[:filename])),
          filename: attachment[:filename],
          content_type: attachment[:content_type]
        )
      end

      pupil_attachments.each do |attachment|
        activity.pupil_resources.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', attachment[:filename])),
          filename: attachment[:filename],
          content_type: attachment[:content_type]
        )
      end

      slide_deck_attachments.each do |attachment|
        activity.slide_deck.attach(
          io: File.open(Rails.root.join(file_fixture(attachment[:filename])), 'rb'),
          filename: attachment[:filename],
          content_type: attachment[:content_type]
        )
      end
    end

    let(:teacher_attachment_filenames) do
      arr = teacher_attachments.map { |ta| ta[:filename] }
      arr << "presentation.odp"
      arr
    end

    let(:pupil_attachment_filenames) do
      pupil_attachments.map { |ta| ta[:filename] }
    end

    let(:download) { create(:download, lesson: activity.lesson_part.lesson) }
    subject { ResourcePackager.new(download).lesson_bundle }

    def strip_paths(entries)
      entries.map { |tr| File.basename(tr) }
    end

    specify 'all attachments should be added to the zip file' do
      Zip::File.open_buffer(subject) do |zip|
        teacher_resources, pupil_resources = *zip.map(&:name).partition do |p|
          p.starts_with?('teacher')
        end

        expect(teacher_attachment_filenames).to match_array(strip_paths(teacher_resources))
        expect(pupil_attachment_filenames).to match_array(strip_paths(pupil_resources))
      end
    end
  end
end
