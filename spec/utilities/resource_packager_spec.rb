require 'rails_helper'

RSpec.describe(ResourcePackager) do
  def strip_paths(entries)
    entries.map { |tr| File.basename(tr) }
  end

  let(:download) { create(:download) }

  subject { ResourcePackager.new(download) }

  it { is_expected.to respond_to(:download) }
  it { is_expected.to respond_to(:lesson_bundle) }

  describe '#lesson_bundle' do
    let(:teacher_attachment_filenames) do
      activity.teacher_resources.map(&:file).map(&:filename).map(&:to_s)
    end

    let(:pupil_attachment_filenames) do
      activity.pupil_resources.map(&:file).map(&:filename).map(&:to_s)
    end

    let(:slide_deck_attachment_filename) do
      'presentation.odp'
    end

    let!(:download) { create(:download, lesson: lesson) }

    subject { ResourcePackager.new(download).lesson_bundle }

    context 'activity has slide deck' do
      let!(:activity) { create(:activity, :with_pupil_resources, :with_teacher_resources, :with_slide_deck) }
      let!(:lesson_part) { activity.lesson_part }
      let!(:lesson) { lesson_part.lesson }

      specify 'all attachments should be added to the zip file' do
        Zip::File.open_buffer(subject) do |zip|
          zipped_file_names = *zip.map(&:name)

          returned_teacher_resources = zipped_file_names.select { |fn| fn.starts_with? 'teacher' }
          returned_pupil_resources = zipped_file_names.select { |fn| fn.starts_with? 'pupil' }

          expect(teacher_attachment_filenames).to match_array(strip_paths(returned_teacher_resources))
          expect(pupil_attachment_filenames).to match_array(strip_paths(returned_pupil_resources))
          expect(zipped_file_names).to include("#{download.lesson.name.parameterize}.odp")
        end
      end

      it "doesn't include any presentations where there's no slide decks" do
        activity.slide_deck_resource.file.detach

        Zip::File.open_buffer(subject) do |zip|
          zip.map(&:name).each do |name|
            expect(name).not_to end_with(".odp")
          end
        end
      end
    end

    context "activity doesn't have a slide deck" do
      let!(:activity) { create :activity, :with_pupil_resources, :with_teacher_resources }
      let!(:lesson_part) { activity.lesson_part }
      let!(:lesson) { lesson_part.lesson }

      specify 'all attachments should be added to the zip file' do
        Zip::File.open_buffer(subject) do |zip|
          zipped_file_names = *zip.map(&:name)

          returned_teacher_resources = zipped_file_names.select { |fn| fn.starts_with? 'teacher' }
          returned_pupil_resources = zipped_file_names.select { |fn| fn.starts_with? 'pupil' }

          expect(teacher_attachment_filenames).to match_array(strip_paths(returned_teacher_resources))
          expect(pupil_attachment_filenames).to match_array(strip_paths(returned_pupil_resources))
        end
      end
    end
  end
end
