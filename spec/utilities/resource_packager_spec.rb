require 'rails_helper'

RSpec.describe(ResourcePackager) do
  let(:download) { create(:download) }

  subject { ResourcePackager.new(download) }

  it { is_expected.to respond_to(:download) }
  it { is_expected.to respond_to(:lesson_bundle) }

  describe '#lesson_bundle' do
    let(:activity) { create(:activity) }
    let!(:teacher_resources) { create_list :teacher_resource, 1, :with_file, activity: activity }
    let!(:pupil_resources) { create_list :pupil_resource, 1, :with_file, activity: activity }

    let(:teacher_attachment_filenames) do
      teacher_resources.map(&:file).map(&:filename).map(&:to_s)
    end

    let(:pupil_attachment_filenames) do
      pupil_resources.map(&:file).map(&:filename).map(&:to_s)
    end

    let(:download) { create(:download, lesson: activity.lesson_part.lesson) }
    subject { ResourcePackager.new(download).lesson_bundle }

    def strip_paths(entries)
      entries.map { |tr| File.basename(tr) }
    end

    specify 'all attachments should be added to the zip file' do
      Zip::File.open_buffer(subject) do |zip|
        returned_teacher_resources, returned_pupil_resources = *zip.map(&:name).partition do |p|
          p.starts_with?('teacher')
        end

        expect(teacher_attachment_filenames).to match_array(strip_paths(returned_teacher_resources))
        expect(pupil_attachment_filenames).to match_array(strip_paths(returned_pupil_resources))
      end
    end
  end
end
