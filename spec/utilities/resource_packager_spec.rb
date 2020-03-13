require 'rails_helper'

RSpec.describe(ResourcePackager) do
  let(:download) { create(:download) }

  subject { ResourcePackager.new(download) }

  it { is_expected.to respond_to(:download) }
  it { is_expected.to respond_to(:lesson_bundle) }

  describe '#lesson_bundle' do
    let(:activity) { create(:activity) }
    let!(:teacher_resources) { create_list :teacher_resource, 1, activity: activity }
    let!(:pupil_resources) { create_list :pupil_resource, 1, activity: activity }
    let!(:slide_deck_resource) { create :slide_deck_resource, activity: activity }

    let(:teacher_attachment_filenames) do
      teacher_resources.map(&:file).map(&:filename).map(&:to_s)
    end

    let(:pupil_attachment_filenames) do
      pupil_resources.map(&:file).map(&:filename).map(&:to_s)
    end

    let(:slide_deck_attachment_filename) do
      'presentation.odp'
    end

    let(:download) { create(:download, lesson: activity.lesson_part.lesson) }
    subject { ResourcePackager.new(download).lesson_bundle }

    def strip_paths(entries)
      entries.map { |tr| File.basename(tr) }
    end

    specify 'all attachments should be added to the zip file' do
      Zip::File.open_buffer(subject) do |zip|
        zipped_file_names = *zip.map(&:name)

        returned_teacher_resources = zipped_file_names.select { |fn| fn.starts_with? 'teacher' }
        returned_pupil_resources = zipped_file_names.select { |fn| fn.starts_with? 'pupil' }

        # FIXME the final presentation is being added into the teacher directory
        # it should be added at the top level of the zip.
        expect(teacher_attachment_filenames + ['presentation.odp']).to match_array(strip_paths(returned_teacher_resources))
        expect(pupil_attachment_filenames).to match_array(strip_paths(returned_pupil_resources))
      end
    end
  end
end
